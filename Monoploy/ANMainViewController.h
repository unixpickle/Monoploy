//
//  ANMainViewController.h
//  Monoploy
//
//  Created by Alex Nichol on 7/17/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANBoardView.h"
#import "ANLoadingView.h"
#import "ANStatisticsGenerator.h"
#import "ANPreferencesViewController.h"
#import "ANCardsViewController.h"

@interface ANMainViewController : UIViewController <ANStatisticsGenerator, ANCardsViewControllerDelegate> {
    ANBoardView * boardView;
    ANCardSet * chance;
    ANCardSet * communityChest;
    
    UIBarButtonItem * calculateButton;
    UIBarButtonItem * settingsButton;
    
    UIButton * chestButton;
    UIButton * chanceButton;
    
    UISlider * movesSlider;
    UILabel * movesLabel;
    
    ANLoadingView * loadingView;
}

- (void)calculate:(id)sender;
- (void)showSettings:(id)sender;
- (void)showCommunityChest:(id)sender;
- (void)showChance:(id)sender;

- (void)sliderChanged:(id)sender;

@end
