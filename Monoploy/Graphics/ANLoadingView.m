//
//  ANLoadingView.m
//  Monoploy
//
//  Created by Alex Nichol on 7/17/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANLoadingView.h"

@implementation ANLoadingView

- (id)init {
    if ((self = [super init])) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
        self.alpha = 0;
        
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        label = [[UILabel alloc] init];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor whiteColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        
        [spinner startAnimating];
        [label setText:@"Working..."];
        
        [self addSubview:spinner];
        [self addSubview:label];
    }
    return self;
}

- (void)showInView:(UIView *)parentView {
    NSAssert(!isShowing, @"Cannot show while already showing");
    shouldHide = NO;
    isShowing = YES;
    
    self.frame = parentView.bounds;
    label.frame = CGRectMake(0, 0, parentView.frame.size.width, 32);
    label.center = CGPointMake(parentView.frame.size.width / 2,
                               parentView.frame.size.height / 2);
    spinner.center = CGPointMake(parentView.frame.size.width / 2,
                                 parentView.frame.size.height / 2 + 35);
    [parentView addSubview:self];
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
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
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
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
