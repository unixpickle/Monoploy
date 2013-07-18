//
//  ANSlideoutView.m
//  Monoploy
//
//  Created by Alex Nichol on 7/18/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANSlideoutView.h"

@implementation ANSlideoutView

@synthesize label;

- (id)initWithFrame:(CGRect)frame orientation:(ANSlideoutViewOrientation)theOrientation {
    if ((self = [super initWithFrame:frame])) {
        orientation = theOrientation;
        if ((orientation & 1) == ANSlideoutViewOrientationVertical) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.width)];
            label.transform = CGAffineTransformMakeRotation(M_PI / 2);
        } else {
            label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        }
        [self addSubview:label];
        label.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        displayFrame = frame;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor colorWithRed:0.8 green:0.9 blue:1 alpha:0.8];
    }
    return self;
}

- (void)displayInView:(UIView *)view {
    CGRect startFrame = displayFrame;
    if ((orientation & 1) == ANSlideoutViewOrientationVertical) {
        if ((orientation & 2)) {
            startFrame.origin.y += startFrame.size.height;
        }
        startFrame.size.height = 0;
    } else {
        if ((orientation & 2)) {
            startFrame.origin.x += startFrame.size.width;
        }
        startFrame.size.width = 0;
    }
    CGRect endFrame = displayFrame;
    [view addSubview:self];
    self.frame = startFrame;
    isShowing = YES;
    shouldHide = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = endFrame;
    } completion:^(BOOL finished) {
        isShowing = NO;
        if (shouldHide) {
            [self hide];
        }
    }];
}

- (void)hide {
    if (isShowing) {
        shouldHide = YES;
        return;
    }
    CGRect endFrame = displayFrame;
    if ((orientation & 1) == ANSlideoutViewOrientationVertical) {
        if ((orientation & 2)) {
            endFrame.origin.y += endFrame.size.height;
        }
        endFrame.size.height = 0;
    } else {
        if ((orientation & 2)) {
            endFrame.origin.x += endFrame.size.width;
        }
        endFrame.size.width = 0;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = endFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)setPercentage:(float)value {
    label.text = [NSString stringWithFormat:@"%.01f%%", (value * 100)];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
