//
//  ANCardSet.h
//  Monoploy
//
//  Created by Alex Nichol on 7/16/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANCard.h"

@interface ANCardSet : NSObject {
    NSString * name; // i.e. Chance or Community Chest
    NSArray * unorderedCards;
    NSArray * orderedCards;
}

@property (readonly) NSString * name;
@property (readonly) NSArray * unorderedCards;
@property (readonly) NSArray * orderedCards;

+ (ANCardSet *)defaultCommunityChest;
+ (ANCardSet *)defaultChance;

- (ANCardSet *)cardSetByDrawing:(ANCard *)card;
- (ANCardSet *)cardSetByShuffling;

/**
 * Returns an array of ANCard objects which may
 * surface in the next draw.
 */
- (NSSet *)possibleDraws;

@end
