//
//  ANPlayerView.m
//  Monoploy
//
//  Created by Alex Nichol on 7/17/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANPlayerView.h"

@implementation ANPlayerView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.9];
        self.layer.cornerRadius = frame.size.width / 2;
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowRadius = 1;
        self.exclusiveTouch = YES;
    }
    return self;
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGFloat radius = 20;
    CGRect frame = CGRectMake(self.frame.size.width / 2 - radius,
                              self.frame.size.height / 2 - radius,
                              self.frame.size.width / 2 + radius,
                              self.frame.size.height / 2 + radius);
    
    if (CGRectContainsPoint(frame, point)) {
        return self;
    }
    return nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self.superview];
    [delegate playerView:self moveToPoint:point];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [delegate playerViewDropped:self];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [delegate playerViewDropped:self];
}

@end
