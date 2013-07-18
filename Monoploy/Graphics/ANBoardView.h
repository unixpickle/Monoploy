//
//  ANBoardView.h
//  Monoploy
//
//  Created by Alex Nichol on 7/17/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ANPlayerView.h"

@interface ANBoardView : UIView {
    double heats[40];
    int playerIndex;
    
    ANPlayerView * player;
    UIImageView * centerImg;
}

@property (readonly) int playerIndex;

- (id)initWithStandardSize:(CGPoint)point;
- (void)setHeat:(double)heat atIndex:(int)index;

@end
