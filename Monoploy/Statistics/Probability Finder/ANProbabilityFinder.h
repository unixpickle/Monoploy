//
//  ANProbabilityFinder.h
//  Monoploy
//
//  Created by Alex Nichol on 7/17/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANPossibleBoard.h"
#import "ANProbabilityMap.h"

@protocol ANProbabilityFinder <NSObject>

- (id)initWithPossibleBoard:(ANPossibleBoard *)board;

// non-compounding methods
- (id)finderForNextTurn;
- (ANProbabilityMap *)probabilityMap;

// compounding methods
- (id)finderForNextTurnExcluding:(int)space;

@end
