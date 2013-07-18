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
- (void)findCompoundedFiniteState;

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
            BOOL compound = [[ANPreferences sharedPreferences] compoundTurns];
            if (compound) {
                [self findCompoundedFiniteState];
            } else {
                [self findFiniteState];
            }
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
    id<ANProbabilityFinder> theFinder = finder;
    
    for (int i = 0; i < depthCount; i++) {
        if (i + 1 == depthCount) {
            result = [theFinder probabilityMap];
            break;
        }
        
        if ([[NSThread currentThread] isCancelled]) return;
        theFinder = [theFinder finderForNextTurn];
    }
}

- (void)findCompoundedFiniteState {
    double values[40];
    for (int space = 0; space < 40; space++) {
        id<ANProbabilityFinder> theFinder = finder;
        for (int i = 0; i < depthCount; i++) {
            if (i + 1 == depthCount) {
                ANProbabilityMap * map = [theFinder probabilityMap];
                values[space] = 1 - [map sumValuesExcluding:space];
                break;
            }
            
            if ([[NSThread currentThread] isCancelled]) return;
            theFinder = [theFinder finderForNextTurnExcluding:space];
        }
    }
    result = [[ANProbabilityMap alloc] initWithValues:values];
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
