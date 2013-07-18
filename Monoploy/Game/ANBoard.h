//
//  ANBoard.h
//  Monoploy
//
//  Created by Alex Nichol on 7/16/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANCardSet.h"

typedef struct {
    int position;
    union {
        int jailRolls;
        int doubleRolls;
    };
} ANBoardState;

ANBoardState ANBoardStateCreate(int pos, int rollCount);

@interface ANBoard : NSObject {
    ANBoardState attributes;
    ANCardSet * chance;
    ANCardSet * communityChest;
}

@property (readonly) ANBoardState attributes;
@property (readonly) int position;
@property (readonly) int jailRolls;
@property (readonly) int doubleRolls;
@property (readonly) ANCardSet * chance;
@property (readonly) ANCardSet * communityChest;

- (id)initWithState:(ANBoardState)state chance:(ANCardSet *)theChance
     communityChest:(ANCardSet *)theCommunityChest;

- (int)closestRailroad;
- (int)closestUtility;

- (int)forwardDistanceTo:(int)position;
- (int)backwardDistanceTo:(int)position;

- (int)positionByAdvancing:(int)steps;
- (int)positionByReversing:(int)steps;

- (int)positionByFollowingCard:(ANCard *)card;

- (id)boardByChangingPosition:(int)newPos;
- (id)boardByChangingJailRolls:(int)newRolls;

@end
