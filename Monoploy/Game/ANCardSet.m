//
//  ANCardSet.m
//  Monoploy
//
//  Created by Alex Nichol on 7/16/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANCardSet.h"

static NSArray * cards_for_count_descriptor(NSArray * descriptions, NSString * descriptor);

@interface ANCardSet (Private)

- (id)initWithName:(NSString *)name unordered:(NSArray *)unordered ordered:(NSArray *)ordered;

@end

@implementation ANCardSet

@synthesize name;
@synthesize unorderedCards;
@synthesize orderedCards;

+ (ANCardSet *)defaultCommunityChest {
    NSString * path = [[NSBundle mainBundle] pathForResource:@"Cards" ofType:@"plist"];
    NSArray * cardDescriptions = [NSArray arrayWithContentsOfFile:path];
    NSArray * cards = cards_for_count_descriptor(cardDescriptions, @"CC");
    return [[ANCardSet alloc] initWithName:@"Community Chest"
                                 unordered:cards ordered:[NSArray array]];
}

+ (ANCardSet *)defaultChance {
    NSString * path = [[NSBundle mainBundle] pathForResource:@"Cards" ofType:@"plist"];
    NSArray * cardDescriptions = [NSArray arrayWithContentsOfFile:path];
    NSArray * cards = cards_for_count_descriptor(cardDescriptions, @"Chance");
    return [[ANCardSet alloc] initWithName:@"Chance"
                                 unordered:cards ordered:[NSArray array]];
}

- (ANCardSet *)cardSetByDrawing:(ANCard *)card {
    if ([orderedCards containsObject:card]) {
        // move the card to the end
        NSMutableArray * cardsCopy = [orderedCards mutableCopy];
        [cardsCopy removeObject:card];
        [cardsCopy addObject:card];
        return [[ANCardSet alloc] initWithName:name
                                     unordered:unorderedCards
                                       ordered:[cardsCopy copy]];
    } else {
        // move the card to the end of the unordered pile
        NSMutableArray * unordered = [unorderedCards mutableCopy];
        NSMutableArray * ordered = [orderedCards mutableCopy];
        [unordered removeObject:card];
        [ordered addObject:card];
        return [[ANCardSet alloc] initWithName:name
                                     unordered:[unordered copy]
                                       ordered:[ordered copy]];
    }
}

- (ANCardSet *)cardSetByShuffling {
    NSMutableArray * mUnordered = [[NSMutableArray alloc] init];
    [mUnordered addObjectsFromArray:orderedCards];
    [mUnordered addObjectsFromArray:unorderedCards];
    NSArray * unordered = [mUnordered sortedArrayUsingSelector:@selector(compare:)];
    return [[ANCardSet alloc] initWithName:name
                                 unordered:unordered
                                   ordered:[NSArray array]];
}

- (ANCardSet *)cardSetByUndrawinng:(ANCard *)card {
    int insertIndex = [unorderedCards count];
    for (int i = 0; i < [unorderedCards count]; i++) {
        ANCard * aCard = [unorderedCards objectAtIndex:i];
        if ([aCard compare:card] == NSOrderedDescending) {
            insertIndex = i;
            break;
        }
    }
    NSMutableArray * unordered = [unorderedCards mutableCopy];
    [unordered insertObject:card atIndex:insertIndex];
    NSMutableArray * ordered = [orderedCards mutableCopy];
    [ordered removeObject:card];
    return [[ANCardSet alloc] initWithName:name
                                 unordered:[unordered copy]
                                   ordered:[ordered copy]];
}

- (NSSet *)possibleDraws {
    if ([unorderedCards count] > 0) {
        return [NSSet setWithArray:unorderedCards];
    } else {
        return [NSSet setWithObject:[orderedCards objectAtIndex:0]];
    }
}

#pragma mark - Private -

- (id)initWithName:(NSString *)theName unordered:(NSArray *)unordered ordered:(NSArray *)ordered {
    if ((self = [super init])) {
        name = theName;
        unorderedCards = unordered;
        orderedCards = ordered;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Name: %@\nUnordered: %@\nOrdered: %@",
            name, unorderedCards, orderedCards];
}

@end

static NSArray * cards_for_count_descriptor(NSArray * descriptions, NSString * descriptor) {
    NSMutableArray * list = [NSMutableArray array];
    for (NSDictionary * description in descriptions) {
        NSNumber * count = [description objectForKey:descriptor];
        NSCAssert([count isKindOfClass:[NSNumber class]], @"Invalid count value");
        for (int i = 0; i < [count intValue]; i++) {
            ANCard * card = [[ANCard alloc] initWithDictionary:description];
            [list addObject:card];
        }
    }
    return [list sortedArrayUsingSelector:@selector(compare:)];
}
