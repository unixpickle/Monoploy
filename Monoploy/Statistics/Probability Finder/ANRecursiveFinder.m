//
//  ANRecursiveFinder.m
//  Monoploy
//
//  Created by Alex Nichol on 7/17/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANRecursiveFinder.h"

@implementation ANRecursiveFinder

- (id)initWithPossibilities:(NSSet *)roots {
    if ((self = [super init])) {
        possibilities = roots;
    }
    return self;
}

- (id)initWithPossibleBoard:(ANPossibleBoard *)board {
    if ((self = [super init])) {
        possibilities = [board expand];
    }
    return self;
}

- (ANProbabilityMap *)probabilityMap {
    float values[40];
    
    for (ANPossibleBoard * board in possibilities) {
        values[board.position] += board.probability;
    }
    
    return [[ANProbabilityMap alloc] initWithValues:values];
}

- (id)finderForNextTurn {
    NSMutableSet * expansion = [[NSMutableSet alloc] init];
    for (ANPossibleBoard * board in possibilities) {
        for (id obj in [board expand]) {
            [expansion addObject:obj];
        }
    }
    return [[ANRecursiveFinder alloc] initWithPossibilities:[expansion copy]];
}

- (id)finderForNextTurnExcluding:(int)space {
    NSMutableSet * expansion = [[NSMutableSet alloc] init];
    for (ANPossibleBoard * board in possibilities) {
        if (board.position == space) continue;
        for (id obj in [board expand]) {
            [expansion addObject:obj];
        }
    }
    return [[ANRecursiveFinder alloc] initWithPossibilities:[expansion copy]];
}

@end
