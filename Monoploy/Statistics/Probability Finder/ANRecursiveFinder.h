//
//  ANRecursiveFinder.h
//  Monoploy
//
//  Created by Alex Nichol on 7/17/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANProbabilityFinder.h"

@interface ANRecursiveFinder : NSObject <ANProbabilityFinder> {
    NSSet * possibilities;
}

- (id)initWithPossibilities:(NSSet *)roots;

@end
