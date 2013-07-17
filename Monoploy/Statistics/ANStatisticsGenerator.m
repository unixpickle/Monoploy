//
//  ANStatisticsGenerator.m
//  Monoploy
//
//  Created by Alex Nichol on 7/17/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANStatisticsGenerator.h"

@interface ANStatisticsGenerator (Private)

- (void)backgroundSearch;

- (void)findSteadyState;
- (void)findFiniteState;

- (void)notifyDelegate;

@end

@implementation ANStatisticsGenerator

@synthesize delegate;
@synthesize result;

- (id)initWithDepthCount:(int)_depthCount root:(ANPossibleBoard *)root {
    if ((self = [super init])) {
        depthCount = _depthCount;
        ANFinderType finderType = [[ANPreferences sharedPreferences] finderType];
        if (depthCount < 0 || finderType == ANFinderTypeMarkov) {
            finder = [[ANMarkovFinder alloc] initWithPossibleBoard:root];
        } else if (finderType == ANFinderTypeRecursive) {
            finder = [[ANRecursiveFinder alloc] initWithPossibleBoard:root];
        } else {
            NSLog(@"Unknown finder specified");
            abort();
        }
    }
    return self;
}

- (void)start {
    NSAssert(backgroundThread == nil, @"Cannot start generator more than once.");
    callbackThread = [NSThread currentThread];
    backgroundThread = [[NSThread alloc] initWithTarget:self
                                               selector:@selector(backgroundSearch)
                                                 object:nil];
    [backgroundThread start];
}

- (void)cancel {
    [backgroundThread cancel];
}

#pragma mark - Private -

- (void)backgroundSearch {
    @autoreleasepool {
        if (depthCount < 0) {
            [self findSteadyState];
        } else {
            [self findFiniteState];
        }
        if ([[NSThread currentThread] isCancelled]) {
            return;
        }
        [self notifyDelegate];
    }
}

- (void)findSteadyState {
    NSAssert([finder isKindOfClass:[ANMarkovFinder class]], @"Markov must be used for steady state.");
    result = [(ANMarkovFinder *)finder steadyStateMap];
}

- (void)findFiniteState {
    BOOL compound = [[ANPreferences sharedPreferences] compoundTurns];
    id<ANProbabilityFinder> theFinder = finder;
    for (int i = 0; i < depthCount; i++) {
        if (compound) {
            ANProbabilityMap * map = [theFinder probabilityMap];
            if (!result) result = map;
            else result = [result mapByAdding:map];
        } else if (i + 1 == depthCount) {
            result = [theFinder probabilityMap];
        }
        
        if (i + 1 == depthCount) break;
        if ([[NSThread currentThread] isCancelled]) return;
        theFinder = [theFinder finderForNextTurn];
    }
    if (compound) {
        result = [result mapByScalingToUnit];
    }
}

- (void)notifyDelegate {
    if ([NSThread currentThread] != callbackThread) {
        [self performSelector:@selector(notifyDelegate)
                     onThread:callbackThread
                   withObject:nil waitUntilDone:NO];
        return;
    }
    [delegate statisticsGeneratorCompleted:self];
}

@end
