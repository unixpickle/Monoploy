//
//  ANMarkovFinder.m
//  Monoploy
//
//  Created by Alex Nichol on 7/17/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANMarkovFinder.h"

#define kANMarkovSize (40*3)

@interface ANMarkovFinder (Private)

+ (ANProbabilityMap *)mapForVector:(ANMatrix *)matrix;

+ (int)rowForBoard:(ANBoard *)board;
+ (id)moveBoard:(ANBoard *)board toRow:(int)row;
+ (int)propertyIndexForRow:(int)row;

@end

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
    if ((self = [super initWithRows:kANMarkovSize columns:kANMarkovSize])) {
        // create a markov matrix
        // columns are sources, rows are destinations
        for (int source = 0; source < kANMarkovSize; source++) {
            ANPossibleBoard * possib = [self.class moveBoard:board toRow:source];
            NSSet * outcomes = [possib expand];
            // compute the total probability of each location
            for (ANPossibleBoard * aBoard in outcomes) {
                int rowIndex = [self.class rowForBoard:aBoard];
                double currentValue = [self itemAtRow:rowIndex column:source];
                currentValue += aBoard.probability;
                [self setItem:currentValue atRow:rowIndex column:source];
            }
        }
        
        // create the initial state vector
        initialState = [[ANMatrix alloc] initWithRows:kANMarkovSize columns:1];
        [initialState setItem:1 atRow:[self.class rowForBoard:board] column:0];
        NSAssert([self.class rowForBoard:board] < 40, @"Initial board shouldn't have rolled state");
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
    ANMatrix * result = [self multiply:initialState];
    return [self.class mapForVector:result];
}

#pragma mark - Compounding -

- (id)finderForNextTurnExcluding:(int)space {
    ANMatrix * nextState = [self multiply:initialState];
    for (int i = 0; i < nextState.rowCount; i++) {
        if ([self.class propertyIndexForRow:i] == space) {
            [nextState setItem:0 atRow:i column:0];
        }
    }
    return [[ANMarkovFinder alloc] initWithMatrix:self
                                          initial:nextState];
}

#pragma mark - Markov Specific -

- (ANProbabilityMap *)steadyStateMap {
    ANMatrix * identity = [ANMatrix identityMatrix:self.columnCount];
    ANMatrix * difference = [self add:[identity scale:-1]];
    ANMatrix * nullspace = [difference nullspaceBasis];
    NSAssert(nullspace.rowCount == self.rowCount && nullspace.columnCount == 1, @"Invalid nullspace");
    return [[self.class mapForVector:nullspace] mapByScalingToUnit];
}

#pragma mark - Private -

+ (ANProbabilityMap *)mapForVector:(ANMatrix *)matrix {
    double values[40];
    bzero(values, sizeof(double) * 40);
    for (int i = 0; i < kANMarkovSize; i++) {
        double val = [matrix itemAtRow:i column:0];
        int property = [self propertyIndexForRow:i];
        values[property] += val;
    }
    return [[ANProbabilityMap alloc] initWithValues:values];
}

+ (int)rowForBoard:(ANBoard *)board {
    return board.position + (board.attributes.jailRolls * 40);
}

+ (id)moveBoard:(ANBoard *)board toRow:(int)row {
    ANBoardState state = ANBoardStateCreate(row % 40, row / 40);
    return [board boardByChangingState:state];
}

+ (int)propertyIndexForRow:(int)row {
    return row % 40;
}

@end
