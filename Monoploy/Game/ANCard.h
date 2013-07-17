//
//  ANCard.h
//  Monoploy
//
//  Created by Alex Nichol on 7/16/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ANCardWhenceRelative,
    ANCardWhenceAbsolute,
    ANCardWhenceRailroad,
    ANCardWhenceUtility
} ANCardWhence;

@interface ANCard : NSObject {
    NSString * name;
    ANCardWhence whence;
    int seek;
}

@property (readonly) NSString * name;
@property (readonly) ANCardWhence whence;
@property (readonly) int seek;

- (id)initWithDictionary:(NSDictionary *)properties;

- (NSString *)title;
- (NSString *)subtitle;
- (NSComparisonResult)compare:(ANCard *)otherCard;

@end
