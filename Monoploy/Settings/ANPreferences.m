//
//  ANPreferences.m
//  Monoploy
//
//  Created by Alex Nichol on 7/17/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANPreferences.h"

@implementation ANPreferences

+ (ANPreferences *)sharedPreferences {
    static ANPreferences * prefs = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        prefs = [[ANPreferences alloc] init];
    });
    return prefs;
}

- (id)init {
    if ((self = [super init])) {
        defaults = [NSUserDefaults standardUserDefaults];
        if (![defaults objectForKey:@"finderType"]) {
            [defaults setInteger:ANFinderTypeMarkov forKey:@"finderType"];
        }
        if (![defaults objectForKey:@"compoundTurns"]) {
            [defaults setBool:YES forKey:@"compoundTurns"];
        }
        if (![defaults objectForKey:@"jailOnlyDoubles"]) {
            [defaults setBool:YES forKey:@"jailOnlyDoubles"];
        }
    }
    return self;
}

- (ANFinderType)finderType {
    return (ANFinderType)[defaults integerForKey:@"finderType"];
}

- (void)setFinderType:(ANFinderType)finderType {
    [defaults setInteger:finderType forKey:@"finderType"];
    [defaults synchronize];
}

- (BOOL)compoundTurns {
    return [defaults boolForKey:@"compoundTurns"];
}

- (void)setCompoundTurns:(BOOL)compoundTurns {
    [defaults setBool:compoundTurns forKey:@"compoundTurns"];
    [defaults synchronize];
}

- (BOOL)jailOnlyDoubles {
    return [defaults boolForKey:@"jailOnlyDoubles"];
}

- (void)setJailOnlyDoubles:(BOOL)jailOnlyDoubles {
    [defaults setBool:jailOnlyDoubles forKey:@"jailOnlyDoubles"];
    [defaults synchronize];
}

@end
