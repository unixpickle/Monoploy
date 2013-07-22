//
//  ANPossibleBoard.m
//  Monoploy
//
//  Created by Alex Nichol on 7/16/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANPossibleBoard.h"

@interface ANPossibleBoard (Private)

- (id)initWithOldBoard:(ANBoard *)board state:(ANBoardState)newState probability:(double)prob;
- (id)initWithChance:(ANCardSet *)theChance
      communityChest:(ANCardSet *)theCommChest
               state:(ANBoardState)state probability:(double)prob;

/**
 * If we are on chance or community chest, this returns a list
 * of all possible destinations. Otherwise, the set contains
 * the current board.
 */
- (NSSet *)expandLocalMoves;

- (ANPossibleBoard *)boardByFollowingCard:(ANCard *)card chance:(BOOL)c
                              probability:(double)prob;

@end

@implementation ANPossibleBoard

@synthesize probability;

- (id)initWithBoard:(ANBoard *)board probability:(double)probs {
    if ((self = [super initWithState:board.attributes
                              chance:board.chance
                      communityChest:board.communityChest])) {
        probability = probs;
    }
    return self;
}

- (NSSet *)expand {
    NSMutableSet * nodes = [NSMutableSet set];
    
    for (int x1 = 1; x1 <= 6; x1++) {
        for (int x2 = 1; x2 <= 6; x2++) {
            int roll = x1 + x2;
            double subProb = self.probability * 1.0/36.0;
            ANPossibleBoard * board = nil;
            ANBoardState newState = [self stateByRolling:roll doubles:(x1 == x2)];
            board = [[ANPossibleBoard alloc] initWithOldBoard:self
                                                        state:newState
                                                  probability:subProb];
            
            NSSet * boardSet = [board expandLocalMoves];
            for (ANPossibleBoard * board in boardSet) {
                [nodes addObject:board];
            }
        }
    }
    
    return [nodes copy];
}

#pragma mark - Overloaded -

- (id)boardByChangingPosition:(int)newPos {
    NSAssert(self.attributes.doubleRolls == 0, @"Should not simply change position.");
    ANBoardState newState = self.attributes;
    newState.position = newPos;
    return [[self.class alloc] initWithChance:self.chance
                               communityChest:self.communityChest
                                        state:newState
                                  probability:self.probability];
}

- (id)boardByChangingState:(ANBoardState)state {
    return [[self.class alloc] initWithOldBoard:self state:state
                                    probability:self.probability];
}

#pragma mark - Private -

- (id)initWithOldBoard:(ANBoard *)board state:(ANBoardState)newState
           probability:(double)prob {
    if ((self = [super initWithState:newState chance:board.chance
                      communityChest:board.communityChest])) {
        probability = prob;
    }
    return self;
}

- (id)initWithChance:(ANCardSet *)theChance
      communityChest:(ANCardSet *)theCommChest
               state:(ANBoardState)newState
         probability:(double)prob {
    if ((self = [super initWithState:newState chance:theChance
                      communityChest:theCommChest])) {
        probability = prob;
    }
    return self;
}

- (NSSet *)expandLocalMoves {
    NSSet * cards = nil;
    BOOL isChance = NO;

    if (2 == self.position || 17 == self.position || 33 == self.position) {
        // community chest
        cards = [self.communityChest possibleDraws];
    } else if (7 == self.position || 22 == self.position || 36 == self.position) {
        // chance
        isChance = YES;
        cards = [self.chance possibleDraws];
    }

    if (!cards) {
        return [NSSet setWithObject:self];
    }
    
    // if there were cards, expand each possibility
    NSMutableSet * result = [NSMutableSet set];
    double prob = self.probability / (double)[cards count];
    
    for (ANCard * card in cards) {
        ANPossibleBoard * board = [self boardByFollowingCard:card chance:isChance
                                                 probability:prob];
        NSSet * subset = nil;
        if (board.position != self.position) {
            subset = [board expandLocalMoves];
        } else {
            subset = [NSSet setWithObject:board];
        }
        for (ANPossibleBoard * aBoard in subset) {
            [result addObject:aBoard];
        }
    }
    return [result copy];
}

- (ANPossibleBoard *)boardByFollowingCard:(ANCard *)card chance:(BOOL)c
                              probability:(double)prob {
    ANCardSet * theChance = self.chance;
    ANCardSet * theCommChest = self.communityChest;
    if (c) {
        theChance = [theChance cardSetByDrawing:card];
    } else {
        theCommChest = [theCommChest cardSetByDrawing:card];
    }
    
    int newPos = [self positionByFollowingCard:card];
    ANBoardState newState = self.attributes;
    newState.position = newPos;
    if (newPos == 30) {
        newState.jailRolls = 0;
    }
    return [[ANPossibleBoard alloc] initWithChance:theChance
                                    communityChest:theCommChest
                                             state:newState
                                       probability:prob];
}

@end
