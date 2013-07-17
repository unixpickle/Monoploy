//
//  ANMarkovFinder.m
//  Monoploy
//
//  Created by Alex Nichol on 7/17/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANMarkovFinder.h"

@implementation ANMarkovFinder

- (id)initWithMatrix:(ANMatrix *)matrix initial:(ANMatrix *)state
              markov:(ANMatrix *)base {
    if ((self = [super initWithRows:matrix.rowCount columns:matrix.columnCount])) {
        for (int i = 0; i < matrix.rowCount; i++) {
            for (int j = 0; j < matrix.columnCount; j++) {
                float item = [matrix itemAtRow:i column:j];
                [self setItem:item atRow:i column:j];
            }
        }
        initialMarkov = base;
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
                float currentValue = [self itemAtRow:position column:source];
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

- (id)finderForNextTurn {
    ANMatrix * nextTurn = [self multiply:initialMarkov];
    ANMatrix * markov = (initialMarkov ? initialMarkov : self);
    return [[ANMarkovFinder alloc] initWithMatrix:nextTurn
                                          initial:initialState
                                           markov:markov];
}

- (ANProbabilityMap *)probabilityMap {
    float values[40];
    ANMatrix * result = [self multiply:initialState];
    for (int i = 0; i < 40; i++) {
        values[i] = [result itemAtRow:i column:0];
    }
    return [[ANProbabilityMap alloc] initWithValues:values];
}

@end
