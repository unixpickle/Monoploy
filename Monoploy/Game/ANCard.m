//
//  ANCard.m
//  Monoploy
//
//  Created by Alex Nichol on 7/16/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANCard.h"

@implementation ANCard

@synthesize name, whence, seek;

- (id)initWithDictionary:(NSDictionary *)properties {
    if ((self = [super init])) {
        NSString * whenceStr = [properties objectForKey:@"Whence"];
        if (![whenceStr isKindOfClass:[NSString class]]) return nil;
        NSDictionary * whenceMap = @{@"Absolute": [NSNumber numberWithInt:ANCardWhenceAbsolute],
                                     @"Relative": [NSNumber numberWithInt:ANCardWhenceRelative],
                                     @"Railroad": [NSNumber numberWithInt:ANCardWhenceRailroad],
                                     @"Utility": [NSNumber numberWithInt:ANCardWhenceUtility]};
        NSNumber * whenceNum = [whenceMap objectForKey:whenceStr];
        if (!whenceNum) return nil;
        whence = [whenceNum intValue];
        
        NSNumber * seekNum = [properties objectForKey:@"Seek"];
        if (![seekNum isKindOfClass:[NSNumber class]]) return nil;
        seek = [seekNum intValue];
        
        name = [properties objectForKey:@"Name"];
        if (![name isKindOfClass:[NSString class]]) return nil;
    }
    return self;
}

- (NSString *)title {
    // check for colon
    NSRange location = [name rangeOfString:@":"];
    if (location.location != NSNotFound) {
        return [name substringToIndex:location.location];
    }
    return name;
}

- (NSString *)subtitle {
    NSRange location = [name rangeOfString:@":"];
    if (location.location != NSNotFound) {
        NSString * value = [name substringFromIndex:location.location + 1];
        NSCharacterSet * whitespace = [NSCharacterSet whitespaceCharacterSet];
        return [value stringByTrimmingCharactersInSet:whitespace];
    }
    return nil;
}

- (NSComparisonResult)compare:(ANCard *)otherCard {
    return [[self title] caseInsensitiveCompare:otherCard.title];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ (%d, %d)", name, whence, seek];
}

@end
