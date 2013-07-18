//
//  ANBoard.m
//  Monoploy
//
//  Created by Alex Nichol on 7/16/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANBoard.h"

#define PHYSICAL_POS(x) (x == 30 ? 10 : x)

@implementation ANBoard

@synthesize communityChest;
@synthesize chance;
@synthesize attributes;

- (int)position {
    return attributes.position;
}

- (int)jailRolls {
    NSAssert(attributes.position == 30, @"Cannot get jail rolls out of jail");
    return attributes.jailRolls;
}

- (int)doubleRolls {
    NSAssert(attributes.position != 30, @"Cannot double roll in jail");
    return attributes.doubleRolls;
}

- (id)initWithState:(ANBoardState)state chance:(ANCardSet *)theChance
     communityChest:(ANCardSet *)theCommunityChest {
    if ((self = [super init])) {
        attributes = state;
        chance = theChance;
        communityChest = theCommunityChest;
    }
    return self;
}

- (int)closestRailroad {
    // railroads are at 5, 15, 25, 35
    int source = PHYSICAL_POS(self.position);
    if (source > 35 || source <= 5) {
        return 5;
    }
    if (source > 5 && source <= 15) {
        return 15;
    }
    if (source > 15 && source <= 25) {
        return 25;
    }
    if (source > 25 && source <= 35) {
        return 35;
    }
    NSLog(@"error: closestRailroad did not return any value");
    abort();
}

- (int)closestUtility {
    // utilities at 12 and 28
    int source = PHYSICAL_POS(self.position);
    if (source > 28 || source <= 12) return 12;
    return 28;
}

- (int)forwardDistanceTo:(int)pos {
    NSAssert(pos >= 0 && pos < 40, @"Position out of bounds");
    int dest = PHYSICAL_POS(pos);
    int source = PHYSICAL_POS(self.position);
    
    if (source <= dest) {
        return dest - source;
    } else {
        return 40 + (dest - source);
    }
}

- (int)backwardDistanceTo:(int)pos {
    NSAssert(pos >= 0 && pos < 40, @"Position out of bounds");
    int source = PHYSICAL_POS(pos);
    int dest = PHYSICAL_POS(self.position);
    
    if (source <= dest) {
        return dest - source;
    } else {
        return 40 + (dest - source);
    }
}

- (int)positionByAdvancing:(int)steps {
    int source = PHYSICAL_POS(self.position);
    return (source + steps) % 40;
}

- (int)positionByReversing:(int)steps {
    int source = PHYSICAL_POS(self.position);
    return (source - steps) % 40;
}

- (int)positionByFollowingCard:(ANCard *)card {
    // follow the whence of the card
    int startPosition = PHYSICAL_POS(self.position);
    if (card.whence == ANCardWhenceAbsolute) {
        startPosition = 0;
    } else if (card.whence == ANCardWhenceRailroad) {
        startPosition = [self closestRailroad];
    } else if (card.whence == ANCardWhenceUtility) {
        startPosition = [self closestUtility];
    }
    return (startPosition + card.seek) % 40;
}

#pragma mark - Generating New Boards -

- (id)boardByChangingPosition:(int)newPos {
    ANBoardState newState = attributes;
    newState.position = newPos;
    newState.doubleRolls = 0;
    return [[ANBoard alloc] initWithState:newState
                                   chance:chance
                           communityChest:communityChest];
}

- (id)boardByChangingJailRolls:(int)newRolls {
    NSAssert(self.position == 30, @"Cannot change jail rolls from jail.");
    ANBoardState newState = attributes;
    newState.jailRolls = newRolls;
    return [[ANBoard alloc] initWithState:newState
                                   chance:chance
                           communityChest:communityChest];
}

@end

ANBoardState ANBoardStateCreate(int pos, int rollCount) {
    ANBoardState state;
    state.position = pos;
    state.jailRolls = rollCount;
    NSCAssert(state.doubleRolls == state.jailRolls, @"Union elements must overlap");
    return state;
}
