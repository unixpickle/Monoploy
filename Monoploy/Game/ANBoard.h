//
//  ANBoard.h
//  Monoploy
//
//  Created by Alex Nichol on 7/16/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANCardSet.h"

@interface ANBoard : NSObject {
    int position;
    ANCardSet * chance;
    ANCardSet * communityChest;
}

@property (readonly) int position;
@property (readonly) ANCardSet * chance;
@property (readonly) ANCardSet * communityChest;

- (id)initWithPosition:(int)pos chance:(ANCardSet *)theChance
        communityChest:(ANCardSet *)theCommunityChest;

- (int)closestRailroad;
- (int)closestUtility;

- (int)forwardDistanceTo:(int)position;
- (int)backwardDistanceTo:(int)position;

- (int)positionByAdvancing:(int)steps;
- (int)positionByReversing:(int)steps;

- (int)positionByFollowingCard:(ANCard *)card;

- (id)boardByChangingPosition:(int)newPos;

@end
