//
//  ANSlideoutView.h
//  Monoploy
//
//  Created by Alex Nichol on 7/18/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ANSlideoutViewOrientationVertical = 0,
    ANSlideoutViewOrientationHorizontal = 1,
    ANSlideoutViewOrientationVerticalUp = 2,
    ANSlideoutViewOrientationHorizontalLeft = 3
} ANSlideoutViewOrientation;

@interface ANSlideoutView : UIView {
    UILabel * label;
    CGRect displayFrame;
    ANSlideoutViewOrientation orientation;
    
    BOOL isShowing;
    BOOL shouldHide;
}

@property (readonly) UILabel * label;

- (id)initWithFrame:(CGRect)frame orientation:(ANSlideoutViewOrientation)orientation;
- (void)displayInView:(UIView *)view;
- (void)hide;

- (void)setPercentage:(float)value;

@end
