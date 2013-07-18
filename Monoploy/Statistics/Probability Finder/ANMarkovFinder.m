//
//  ANMarkovFinder.m
//  Monoploy
//
//  Created by Alex Nichol on 7/17/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANMarkovFinder.h"

@interface ANMarkovFinder (Private)

+ (ANProbabilityMap *)mapForVector:(ANMatrix *)matrix;
+ (int)rowForBoard:(ANBoard *)board;
+ (id)moveBoard:(ANBoard *)board toRow:(int)row;

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
    if ((self = [super initWithRows:42 columns:42])) {
        // create a markov matrix
        // columns are sources, rows are destinations
        for (int source = 0; source < 42; source++) {
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
        initialState = [[ANMatrix alloc] initWithRows:42 columns:1];
        [initialState setItem:1 atRow:[self.class rowForBoard:board] column:0];
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
    [nextState setItem:0 atRow:space column:0];
    if (space == 30) {
        [nextState setItem:0 atRow:40 column:0];
        [nextState setItem:0 atRow:41 column:0];
    }
    return [[ANMarkovFinder alloc] initWithMatrix:self
                                          initial:nextState];
}

#pragma mark - Markov Specific -

- (ANProbabilityMap *)steadyStateMap {
    ANMatrix * identity = [ANMatrix identityMatrix:42];
    ANMatrix * difference = [self add:[identity scale:-1]];
    ANMatrix * nullspace = [difference nullspaceBasis];
    NSAssert(nullspace.rowCount == 42 && nullspace.columnCount == 1, @"Invalid nullspace");
    return [[self.class mapForVector:nullspace] mapByScalingToUnit];
}

#pragma mark - Private -

+ (ANProbabilityMap *)mapForVector:(ANMatrix *)matrix {
    double values[40];
    for (int i = 0; i < 40; i++) {
        values[i] = [matrix itemAtRow:i column:0];
    }
    values[30] += [matrix itemAtRow:40 column:0];
    values[30] += [matrix itemAtRow:41 column:0];
    return [[ANProbabilityMap alloc] initWithValues:values];
}

+ (int)rowForBoard:(ANBoard *)board {
    if (board.position == 30) {
        NSAssert(board.jailRolls < 3, @"Board cannot have more than 2 rolls in jail.");
        if (board.jailRolls == 0) {
            return 30;
        }
        return board.jailRolls + 39;
    } else {
        return board.position;
    }
}

+ (id)moveBoard:(ANBoard *)board toRow:(int)row {
    if (row < 40) {
        return [board boardByChangingPosition:row];
    } else {
        id newPos = [board boardByChangingPosition:30];
        return [newPos boardByChangingJailRolls:(row - 39)];
    }
}

@end
