//
//  ANProbabilityMap.m
//  Monoploy
//
//  Created by Alex Nichol on 7/17/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANProbabilityMap.h"

@implementation ANProbabilityMap

- (id)initWithValues:(float *)theValues {
    if ((self = [super init])) {
        memcpy(values, theValues, sizeof(float) * 40);
    }
    return self;
}

- (float)probabilityForSpace:(int)space {
    return values[space];
}

/**
 * Adds vector anotherMap to self.
 */
- (ANProbabilityMap *)mapByAdding:(ANProbabilityMap *)anotherMap {
    float newValues[40];
    for (int i = 0; i < 40; i++) {
        newValues[i] = [self probabilityForSpace:i] + [anotherMap probabilityForSpace:i];
    }
    return [[ANProbabilityMap alloc] initWithValues:newValues];
}

/**
 * Returns a vector for whose values sum to exactly 1.
 */
- (ANProbabilityMap *)mapByScalingToUnit {
    float sum = 0, newValues[40];
    for (int i = 0; i < 40; i++) {
        sum += [self probabilityForSpace:i];
    }
    if (sum == 1) return self;
    for (int i = 0; i < 40; i++) {
        newValues[i] /= sum;
    }
    return [[ANProbabilityMap alloc] initWithValues:newValues];
}

@end
