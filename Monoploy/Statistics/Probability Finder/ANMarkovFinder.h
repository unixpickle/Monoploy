//
//  ANMarkovFinder.h
//  Monoploy
//
//  Created by Alex Nichol on 7/17/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANMatrix.h"
#import "ANProbabilityFinder.h"

/**
 * This is a probability finder based on markov chains
 */
@interface ANMarkovFinder : ANMatrix <ANProbabilityFinder> {
    ANMatrix * initialState;
    ANMatrix * initialMarkov;
}

- (id)initWithMatrix:(ANMatrix *)matrix initial:(ANMatrix *)state
              markov:(ANMatrix *)base;
- (ANProbabilityMap *)steadyStateMap;

@end
