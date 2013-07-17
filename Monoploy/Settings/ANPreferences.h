//
//  ANPreferences.h
//  Monoploy
//
//  Created by Alex Nichol on 7/17/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ANFinderTypeMarkov,
    ANFinderTypeRecursive
} ANFinderType;

@interface ANPreferences : NSObject {
    NSUserDefaults * defaults;
}

+ (ANPreferences *)sharedPreferences;

@property (readwrite) ANFinderType finderType;
@property (readwrite) BOOL compoundTurns;
@property (readwrite) BOOL jailOnlyDoubles;

@end
