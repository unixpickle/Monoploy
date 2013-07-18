//
//  ANProbabilityMap.m
//  Monoploy
//
//  Created by Alex Nichol on 7/17/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANProbabilityMap.h"

@implementation ANProbabilityMap

- (id)initWithValues:(double *)theValues {
    if ((self = [super init])) {
        memcpy(values, theValues, sizeof(double) * 40);
    }
    return self;
}

- (double)probabilityForSpace:(int)space {
    return values[space];
}

/**
 * Adds vector anotherMap to self.
 */
- (ANProbabilityMap *)mapByAdding:(ANProbabilityMap *)anotherMap {
    double newValues[40];
    for (int i = 0; i < 40; i++) {
        newValues[i] = [self probabilityForSpace:i] + [anotherMap probabilityForSpace:i];
    }
    return [[ANProbabilityMap alloc] initWithValues:newValues];
}

/**
 * Returns a vector for whose values sum to exactly 1.
 */
- (ANProbabilityMap *)mapByScalingToUnit {
    double sum = 0, newValues[40];
    sum = [self sumValues];
    memcpy(newValues, values, sizeof(double) * 40);
    for (int i = 0; i < 40; i++) {
        newValues[i] /= sum;
    }
    return [[ANProbabilityMap alloc] initWithValues:newValues];
}

- (double)sumValues {
    return [self sumValuesExcluding:-1];
}

- (double)sumValuesExcluding:(int)index {
    double sum = 0;
    for (int i = 0; i < 40; i++) {
        if (i == index) continue;
        sum += values[i];
    }
    return sum;
}

- (NSString *)description {
    NSMutableString * buffer = [NSMutableString stringWithString:@"map["];
    for (int i = 0; i < 40; i++) {
        [buffer appendFormat:@"%.03f%@", values[i], i != 39 ? @" " : @"]"];
    }
    return [buffer copy];
}

@end
