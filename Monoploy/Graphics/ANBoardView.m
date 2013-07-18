//
//  ANBoardView.m
//  Monoploy
//
//  Created by Alex Nichol on 7/17/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANBoardView.h"

#define kAddSlidedown 25

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
        player.delegate = self;
        [self addSubview:player];
        self.backgroundColor = [UIColor clearColor];
        
        self.layer.cornerRadius = 3;
        self.layer.backgroundColor = [[UIColor colorWithRed:51.0/180.0 green:130.0/180.0
                                                     blue:70.0/180.0 alpha:1] CGColor];
        
        slideoutViews = [[NSMutableArray alloc] init];
        for (int i = 0; i < 40; i++) {
            [slideoutViews addObject:[NSNull null]];
        }
    }
    return self;
}

- (void)setHeat:(double)heat atIndex:(int)index {
    heats[index] = heat;
    if (![[slideoutViews objectAtIndex:index] isEqual:[NSNull null]]) {
        ANSlideoutView * view = [slideoutViews objectAtIndex:index];
        [view setPercentage:heat];
    }
}

- (ANSlideoutView *)slideoutViewForSpace:(int)space {
    id obj = [slideoutViews objectAtIndex:space];
    if ([[NSNull null] isEqual:obj]) {
        // generate it
        ANSlideoutViewOrientation orientation;
        CGRect frame = [self frameForSquare:space];
        if ((space > 0 && space < 10) || space == 20 || space == 30) {
            orientation = ANSlideoutViewOrientationVertical;
            frame.size.height += kAddSlidedown;
            frame.origin.y += 28;
        } else if (space > 10 && space < 20) {
            orientation = ANSlideoutViewOrientationHorizontalLeft;
            frame.size.width += kAddSlidedown;
            frame.origin.x -= 28 + kAddSlidedown;
        } else if ((space >  20 && space < 30) || space == 0 || space == 10) {
            orientation = ANSlideoutViewOrientationVerticalUp;
            frame.size.height += kAddSlidedown;
            frame.origin.y -= 28 + kAddSlidedown;
        } else {
            orientation = ANSlideoutViewOrientationHorizontal;
            frame.size.width += kAddSlidedown;
            frame.origin.x += 28;
        }
        ANSlideoutView * view = [[ANSlideoutView alloc] initWithFrame:frame orientation:orientation];
        [slideoutViews replaceObjectAtIndex:space withObject:view];
        return view;
    }
    return obj;
}

#pragma mark - User Interaction -

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    int choseIndex = -1;
    for (int i = 0; i < 40; i++) {
        if (CGRectContainsPoint([self frameForSquare:i], point)) {
            choseIndex = i;
        }
    }
    if (choseIndex < 0) return;
    
    ANSlideoutView * view = [self slideoutViewForSpace:choseIndex];
    [view setPercentage:heats[choseIndex]];
    if (!view.superview) {
        [view displayInView:self];
    } else {
        [view hide];
    }
}

- (void)playerView:(ANPlayerView *)thePlayer moveToPoint:(CGPoint)p {
    thePlayer.center = p;
    [self bringSubviewToFront:thePlayer];
}

- (void)playerViewDropped:(ANPlayerView *)thePlayer {
    CGPoint point = player.center;
    int choseIndex = -1;
    for (int i = 0; i < 40; i++) {
        if (CGRectContainsPoint([self frameForSquare:i], point)) {
            choseIndex = i;
        }
    }
    if (choseIndex >= 0) playerIndex = choseIndex;
    [UIView animateWithDuration:0.25 animations:^{
        player.frame = CGRectInset([self frameForSquare:playerIndex], 5, 5);
    }];
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
                                                     cornerRadius:3];
    
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
    if (kRemoveOutliars) {
        double otherDistance = 0;
        for (int i = 0; i < 40; i++) {
            if (heats[i] == maxHeat) continue;
            otherDistance = MAX(heats[i], otherDistance);
        }
        if (otherDistance / maxHeat < 0.5) {
            maxHeat = otherDistance;
        }
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
    
    // draw border
    CGContextBeginPath(context);
    CGFloat borderWidth = 1.0 / [[UIScreen mainScreen] scale];
    UIBezierPath * innerBorder = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, borderWidth / 2,
                                                                                     borderWidth / 2)
                                                       byRoundingCorners:UIRectCornerAllCorners
                                                             cornerRadii:CGSizeMake(3, 3)];
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetGrayStrokeColor(context, 0, 1);
    CGContextAddPath(context, [innerBorder CGPath]);
    CGContextStrokePath(context);
}

@end
