//
//  ANMainViewController.m
//  Monoploy
//
//  Created by Alex Nichol on 7/17/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANMainViewController.h"

@interface ANMainViewController ()

- (void)generateNavButtons;
- (void)generateBoardButtons;
- (void)generateMovesSlider;

@end

@implementation ANMainViewController

- (void)viewDidLoad {
    self.title = @"Monoploy";
    [super viewDidLoad];
    
    UIImage * bgImage = [UIImage imageNamed:@"background"];
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [bg setContentMode:UIViewContentModeScaleAspectFill];
    [bg setImage:bgImage];
    [self.view addSubview:bg];
    
    boardView = [[ANBoardView alloc] initWithStandardSize:CGPointMake(6, 6)];
    [self.view addSubview:boardView];
    
    [self generateNavButtons];
    [self generateBoardButtons];
    [self generateMovesSlider];
    
    loadingView = [[ANLoadingView alloc] init];
    chance = [ANCardSet defaultChance];
    communityChest = [ANCardSet defaultCommunityChest];
}

- (void)statisticsGeneratorCompleted:(ANStatisticsGenerator *)gen {
    [loadingView hide];
    ANProbabilityMap * map = gen.result;
    NSLog(@"%@", map);
    for (int i = 0; i < 40; i++) {
        [boardView setHeat:[map probabilityForSpace:i]
                   atIndex:i];
    }
    [boardView setNeedsDisplay];
}

#pragma mark - Button Events -

- (void)calculate:(id)sender {
    [loadingView showInView:self.view];
    int depth = round(movesSlider.value);
    if (depth == 10) depth = -1;
    
    ANBoard * board = [[ANBoard alloc] initWithPosition:boardView.playerIndex
                                                 chance:chance
                                         communityChest:communityChest];
    ANPossibleBoard * posBoard = [[ANPossibleBoard alloc] initWithBoard:board probability:1];
    ANStatisticsGenerator * generator = [[ANStatisticsGenerator alloc] initWithDepthCount:depth
                                                                                     root:posBoard];
    [generator setDelegate:self];
    [generator start];
}

- (void)showSettings:(id)sender {
    
}

- (void)showCommunityChest:(id)sender {
    
}

- (void)showChance:(id)sender {
    
}

#pragma mark - Other Events -

- (void)sliderChanged:(id)sender {
    int moves = round(movesSlider.value);
    if (moves == 10) {
        movesLabel.text = @"\u221e moves";
    } else {
        movesLabel.text = [NSString stringWithFormat:@"%d move%@", moves,
                           (moves > 1 ? @"s" : @"")];
    }
}

#pragma mark - Private -

- (void)generateNavButtons {
    UIImage * gear = [UIImage imageNamed:@"settings"];
    settingsButton = [[UIBarButtonItem alloc] initWithImage:gear style:UIBarButtonItemStyleBordered
                                                     target:self action:@selector(showSettings:)];
    [self.navigationItem setLeftBarButtonItem:settingsButton];
    
    calculateButton = [[UIBarButtonItem alloc] initWithTitle:@"Calculate"
                                                       style:UIBarButtonItemStyleBordered
                                                      target:self action:@selector(calculate:)];
    [self.navigationItem setRightBarButtonItem:calculateButton];
}

- (void)generateBoardButtons {
    chestButton = [UIButton buttonWithType:UIButtonTypeCustom];
    chestButton.frame = CGRectMake(40, 40, 90, 90);
    [chestButton setImage:[UIImage imageNamed:@"chest_btn"]
                 forState:UIControlStateNormal];
    [chestButton addTarget:self action:@selector(showCommunityChest:)
          forControlEvents:UIControlEventTouchUpInside];
    [boardView addSubview:chestButton];
    chestButton.layer.shadowColor = [[UIColor colorWithRed:1 green:1 blue:0.2 alpha:1] CGColor];
    chestButton.layer.shadowRadius = 5;
    chestButton.layer.shadowOpacity = 0.5;
    chestButton.layer.shadowOffset = CGSizeMake(0, 1);
    
    chanceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    chanceButton.frame = CGRectMake(308 - 130, 308 - 130, 90, 90);
    [chanceButton setImage:[UIImage imageNamed:@"chance_btn"]
                  forState:UIControlStateNormal];
    [chanceButton addTarget:self action:@selector(showChance:)
           forControlEvents:UIControlEventTouchUpInside];
    [boardView addSubview:chanceButton];
    chanceButton.layer.shadowColor = [[UIColor colorWithRed:1 green:1 blue:0.2 alpha:1] CGColor];
    chanceButton.layer.shadowRadius = 5;
    chanceButton.layer.shadowOpacity = 0.5;
    chanceButton.layer.shadowOffset = CGSizeMake(0, 1);
}

- (void)generateMovesSlider {
    movesSlider = [[UISlider alloc] initWithFrame:CGRectMake(10, 330, 180, 35)];
    movesSlider.minimumValue = 1;
    movesSlider.maximumValue = 10;
    movesSlider.value = 3;
    [movesSlider addTarget:self action:@selector(sliderChanged:)
          forControlEvents:UIControlEventValueChanged];
    
    movesLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 330, 110, 35)];
    movesLabel.layer.cornerRadius = 5;
    movesLabel.text = @"3 moves";
    movesLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:movesSlider];
    [self.view addSubview:movesLabel];
}

@end
