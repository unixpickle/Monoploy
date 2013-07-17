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
- (id)finderForNextTurn;
- (ANProbabilityMap *)probabilityMap;

@end
