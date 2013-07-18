//
//  ANMarkovFinder.m
//  Monoploy
//
//  Created by Alex Nichol on 7/17/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANMarkovFinder.h"

@implementation ANMarkovFinder

- (id)initWithMatrix:(ANMatrix *)matrix initial:(ANMatrix *)state {
    if ((self = [super initWithRows:matrix.rowCount columns:matrix.columnCount])) {
        for (int i = 0; i < matrix.rowCount; i++) {
            for (int j = 0; j < matrix.columnCount; j++) {
                double item = [matrix itemAtRow:i column:j];
                [self setItem:item atRow:i column:j];
            }
        }
        initialState = state;
    }
    return self;
}

- (id)initWithPossibleBoard:(ANPossibleBoard *)board {
    if ((self = [super initWithRows:40 columns:40])) {
        // create a markov matrix
        // columns are sources, rows are destinations
        for (int source = 0; source < 40; source++) {
            ANPossibleBoard * possib = [board boardByChangingPosition:source];
            NSSet * outcomes = [possib expand];
            // compute the total probability of each location
            for (ANPossibleBoard * board in outcomes) {
                int position = board.position;
                double currentValue = [self itemAtRow:position column:source];
                currentValue += board.probability;
                [self setItem:currentValue atRow:position column:source];
            }
        }
        
        // create the initial state vector
        initialState = [[ANMatrix alloc] initWithRows:40 columns:1];
        [initialState setItem:1 atRow:board.position column:0];
    }
    return self;
}

#pragma mark - Non-compounding -

- (id)finderForNextTurn {
    ANMatrix * nextState = [self multiply:initialState];
    return [[ANMarkovFinder alloc] initWithMatrix:self
                                          initial:nextState];
}

- (ANProbabilityMap *)probabilityMap {
    double values[40];
    ANMatrix * result = [self multiply:initialState];
    for (int i = 0; i < 40; i++) {
        values[i] = [result itemAtRow:i column:0];
    }
    return [[ANProbabilityMap alloc] initWithValues:values];
}

#pragma mark - Compounding -

- (id)finderForNextTurnExcluding:(int)space {
    ANMatrix * nextState = [self multiply:initialState];
    [nextState setItem:0 atRow:space column:0];
    return [[ANMarkovFinder alloc] initWithMatrix:self
                                          initial:nextState];
}

#pragma mark - Markov Specific -

- (ANProbabilityMap *)steadyStateMap {
    ANMatrix * identity = [ANMatrix identityMatrix:40];
    ANMatrix * difference = [self add:[identity scale:-1]];
    ANMatrix * nullspace = [difference nullspaceBasis];
    NSAssert(nullspace.rowCount == 40 && nullspace.columnCount == 1, @"Invalid nullspace");
    double values[40];
    for (int i = 0; i < 40; i++) {
        values[i] = [nullspace itemAtRow:i column:0];
    }
    return [[[ANProbabilityMap alloc] initWithValues:values] mapByScalingToUnit];
}

@end
