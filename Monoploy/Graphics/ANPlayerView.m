//
//  ANPlayerView.m
//  Monoploy
//
//  Created by Alex Nichol on 7/17/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANPlayerView.h"

@implementation ANPlayerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0 alpha:1];
        self.layer.cornerRadius = frame.size.width / 2;
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.layer.shadowOpacity = 1;
        self.layer.shadowOffset = CGSizeMake(2, 2);
    }
    return self;
}


@end
