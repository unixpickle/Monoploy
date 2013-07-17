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
    float probability;
}

@property (readonly) float probability;

- (id)initWithBoard:(ANBoard *)board probability:(float)probs;
- (NSSet *)expand;

@end
