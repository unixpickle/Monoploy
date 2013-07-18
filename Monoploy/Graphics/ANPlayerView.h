//
//  ANPlayerView.h
//  Monoploy
//
//  Created by Alex Nichol on 7/17/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class ANPlayerView;

@protocol ANPlayerViewDelegate

- (void)playerView:(ANPlayerView *)player moveToPoint:(CGPoint)p;
- (void)playerViewDropped:(ANPlayerView *)player;

@end

@interface ANPlayerView : UIView {
    __weak id<ANPlayerViewDelegate> delegate;
}

@property (nonatomic, weak) id<ANPlayerViewDelegate> delegate;

@end
