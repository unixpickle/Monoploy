//
//  ANBoardView.m
//  Monoploy
//
//  Created by Alex Nichol on 7/17/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANBoardView.h"

@interface ANBoardView (Private)

- (void)populateImages;
- (CGRect)frameForSquare:(int)square;

@end

@implementation ANBoardView

@synthesize playerIndex;

- (id)initWithStandardSize:(CGPoint)point {
    CGRect frame = CGRectMake(point.x, point.y, 308, 308);
    if ((self = [super initWithFrame:frame])) {
        [self populateImages];
        player = [[ANPlayerView alloc] initWithFrame:CGRectInset([self frameForSquare:0], 5, 5)];
        [self addSubview:player];
        
        centerImg = [[UIImageView alloc] initWithFrame:CGRectMake(28, 28, 252, 252)];
        [centerImg setImage:[UIImage imageNamed:@"boardbg"]];
        [centerImg setContentMode:UIViewContentModeScaleToFill];
        [self addSubview:centerImg];
        
        self.backgroundColor = [UIColor clearColor];
        
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowOffset = CGSizeMake(5, 5);
        self.layer.borderColor = [[UIColor blackColor] CGColor];
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 5;
    }
    return self;
}

- (void)setHeat:(double)heat atIndex:(int)index {
    heats[index] = heat;
}

#pragma mark - Touches -

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    int choseIndex = -1;
    for (int i = 0; i < 40; i++) {
        if (CGRectContainsPoint([self frameForSquare:i], point)) {
            choseIndex = i;
        }
    }
    if (choseIndex < 0) return;
    playerIndex = choseIndex;
    player.frame = CGRectInset([self frameForSquare:playerIndex], 5, 5);
}

#pragma mark - Private -

- (void)populateImages {
    NSArray * chestSquares = @[@2, @17, @33];
    NSArray * chanceSquares = @[@7, @22, @36];
    NSArray * railroads = @[@5, @15, @25, @35];
    for (NSNumber * chestSquare in chestSquares) {
        UIImage * image = [UIImage imageNamed:@"chest"];
        UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = [self frameForSquare:chestSquare.intValue];
        [self addSubview:imageView];
    }
    for (NSNumber * chanceSquare in chanceSquares) {
        UIImage * image = [UIImage imageNamed:@"chance"];
        UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = [self frameForSquare:chanceSquare.intValue];
        [self addSubview:imageView];
    }
    for (NSNumber * railroadSquare in railroads) {
        UIImage * image = [UIImage imageNamed:@"railroad"];
        UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = [self frameForSquare:railroadSquare.intValue];
        [self addSubview:imageView];
    }
    UIImage * go = [UIImage imageNamed:@"go"];
    UIImageView * goImage = [[UIImageView alloc] initWithImage:go];
    goImage.frame = [self frameForSquare:0];
    [self addSubview:goImage];
}

- (CGRect)frameForSquare:(int)square {
    if (square <= 10) {
        return CGRectMake(28 * square, 0, 28, 28);
    } else if (square <= 20) {
        return CGRectMake(280, 28 * (square - 10), 28, 28);
    } else if (square <= 30) {
        return CGRectMake(280 - (square - 20) * 28, 280, 28, 28);
    } else {
        return CGRectMake(0, 280 - (square - 30) * 28, 28, 28);
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                     cornerRadius:5];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextBeginPath(context);
    CGContextAddPath(context, [path CGPath]);
    CGContextClip(context);
    
    double maxHeat = 0;
    for (int i = 0; i < 40; i++) {
        maxHeat = MAX(heats[i], maxHeat);
    }
    
    // outliar protection
    double otherDistance = 0;
    for (int i = 0; i < 40; i++) {
        if (heats[i] == maxHeat) continue;
        otherDistance = MAX(heats[i], otherDistance);
    }
    if (otherDistance / maxHeat < 0.5) {
        NSLog(@"outliar detected");
        maxHeat = otherDistance;
    }
    
    for (int i = 0; i < 40; i++) {
        CGRect frame = [self frameForSquare:i];
        if (heats[i] < 0.001) {
            double color = 1.0 - (double)(i % 2) / 10.0;
            CGContextSetGrayFillColor(context, color, 1);
        } else {
            double hotness = heats[i] / maxHeat;
            if (heats[i] > maxHeat) {
                hotness = 1;
            }
            CGContextSetRGBFillColor(context, 1, 1.0 - hotness, 1.0 - hotness, 1);
        }
        CGContextFillRect(context, frame);
    }
    
    CGContextRestoreGState(context);
}

@end
