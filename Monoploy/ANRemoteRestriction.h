//
//  ANRemoteRestriction.h
//  Monoploy
//
//  Created by Alex Nichol on 7/18/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kRemoteRestrictionsEnabled NO

@interface ANRemoteRestriction : NSObject

+ (BOOL)shouldTerminate;

@end
