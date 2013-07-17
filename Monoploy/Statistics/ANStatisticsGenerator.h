//
//  ANStatisticsGenerator.h
//  Monoploy
//
//  Created by Alex Nichol on 7/17/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANMarkovFinder.h"
#import "ANRecursiveFinder.h"

@class ANStatisticsGenerator;

@protocol ANStatisticsGenerator

- (void)statisticsGeneratorCompleted:(ANStatisticsGenerator *)gen;

@end

@interface ANStatisticsGenerator : NSObject {
    id<ANProbabilityFinder> finder;
    int depthCount; // -1 implies steady state
    id<ANStatisticsGenerator> delegate;
    
    NSThread * callbackThread;
    NSThread * backgroundThread;
    ANProbabilityMap * result;
}

@property (nonatomic, retain) id<ANStatisticsGenerator> delegate;
@property (readonly) ANProbabilityMap * result;

- (id)initWithDepthCount:(int)depthCount root:(ANPossibleBoard *)root;
- (void)start;
- (void)cancel;

@end
