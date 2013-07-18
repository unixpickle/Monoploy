//
//  ANPossibleBoard.h
//  Monoploy
//
//  Created by Alex Nichol on 7/16/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANBoard.h"
#import "ANMatrix.h"
#import "ANPreferences.h"

@interface ANPossibleBoard : ANBoard {
    double probability;
    int jailRolls;
}

@property (readonly) double probability;

- (id)initWithBoard:(ANBoard *)board probability:(double)probs;
- (NSSet *)expand;

@end
