//
//  ANPossibleBoard.m
//  Monoploy
//
//  Created by Alex Nichol on 7/16/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANPossibleBoard.h"

@interface ANPossibleBoard (Private)

- (id)initWithOldBoard:(ANBoard *)board position:(int)loc probability:(double)prob;
- (id)initWithChance:(ANCardSet *)theChance
      communityChest:(ANCardSet *)theCommChest
            position:(int)loc probability:(double)prob;

/**
 * If we are on chance or community chest, this returns a list
 * of all possible destinations. Otherwise, the set contains
 * the current board.
 */
- (NSSet *)expandLocalMoves;

- (ANPossibleBoard *)boardByFollowingCard:(ANCard *)card chance:(BOOL)c
                              probability:(double)prob;
- (void)setJailRolls:(int)rolls;

@end

@implementation ANPossibleBoard

@synthesize probability;

- (id)initWithBoard:(ANBoard *)board probability:(double)probs {
    if ((self = [super initWithPosition:board.position
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
            int newLoc = [self positionByAdvancing:roll];
            
            // if we are in jail, there's an extra parameter to consider
            int nextJailRolls = 0;
            if (position == 30) {
                if ([[ANPreferences sharedPreferences] jailOnlyDoubles] && jailRolls < 3) {
                    if (x1 != x2) {
                        newLoc = position;
                        nextJailRolls = jailRolls + 1;
                    }
                }
            }
            
            ANPossibleBoard * board = [[ANPossibleBoard alloc] initWithOldBoard:self
                                                                       position:newLoc
                                                                    probability:subProb];
            [board setJailRolls:nextJailRolls];
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
    return [[self.class alloc] initWithChance:self.chance
                               communityChest:self.communityChest
                                     position:newPos
                                  probability:self.probability];
}

#pragma mark - Private -

- (id)initWithOldBoard:(ANBoard *)board position:(int)loc probability:(double)prob {
    if ((self = [super initWithPosition:loc chance:board.chance
                         communityChest:board.communityChest])) {
        probability = prob;
    }
    return self;
}

- (id)initWithChance:(ANCardSet *)theChance
      communityChest:(ANCardSet *)theCommChest
            position:(int)loc probability:(double)prob {
    if ((self = [super initWithPosition:loc chance:theChance
                         communityChest:theCommChest])) {
        probability = prob;
    }
    return self;
}

- (NSSet *)expandLocalMoves {
    NSSet * cards = nil;
    BOOL isChance = NO;

    if (2 == position || 17 == position || 33 == position) {
        // community chest
        cards = [self.communityChest possibleDraws];
    } else if (7 == position || 22 == position || 36 == position) {
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
        [result addObject:board];
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
    return [[ANPossibleBoard alloc] initWithChance:theChance
                                    communityChest:theCommChest
                                          position:newPos
                                       probability:prob];
}

- (void)setJailRolls:(int)rolls {
    jailRolls = rolls;
}

@end
