//
//  ANRemoteRestriction.m
//  Monoploy
//
//  Created by Alex Nichol on 7/18/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANRemoteRestriction.h"

@implementation ANRemoteRestriction

+ (BOOL)shouldTerminate {
    if (!kRemoteRestrictionsEnabled) return NO;
    NSURL * url = [NSURL URLWithString:@"http://aqnichol.com/apps/key.txt"];
    NSURLRequest * req = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                      timeoutInterval:15];
    NSData * data = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil];
    NSString * str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    return ![str isEqual:@"monkey"];
}

@end
