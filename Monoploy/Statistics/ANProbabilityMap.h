//
//  ANProbabilityMap.h
//  Monoploy
//
//  Created by Alex Nichol on 7/17/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * This is essentially a 40 element markov
 * probability vector.
 */
@interface ANProbabilityMap : NSObject {
    float values[40];
}

- (id)initWithValues:(float *)values;
- (float)probabilityForSpace:(int)space;

/**
 * Adds vector anotherMap to self.
 */
- (ANProbabilityMap *)mapByAdding:(ANProbabilityMap *)anotherMap;

/**
 * Returns a vector for whose values sum to exactly 1.
 */
- (ANProbabilityMap *)mapByScalingToUnit;

@end
