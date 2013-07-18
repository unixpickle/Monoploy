//
//  ANLoadingView.h
//  Monoploy
//
//  Created by Alex Nichol on 7/17/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANLoadingView : UIView {
    UIActivityIndicatorView * spinner;
    UILabel * label;
    
    BOOL shouldHide;
    BOOL isShowing;
}

- (void)showInView:(UIView *)parentView;
- (void)hide;

@end
