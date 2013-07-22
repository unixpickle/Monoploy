//
//  ANCardsViewController.h
//  Monoploy
//
//  Created by Alex Nichol on 7/19/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANCardSet.h"

@class ANCardsViewController;

@protocol ANCardsViewControllerDelegate

- (void)cardsViewControllerChanged:(ANCardsViewController *)cvc;

@end

@interface ANCardsViewController : UITableViewController <UIActionSheetDelegate> {
    ANCardSet * cards;
    __weak id<ANCardsViewControllerDelegate> delegate;
    
    NSIndexPath * selectedIndex;
}

@property (readonly) ANCardSet * cards;
@property (nonatomic, weak) id<ANCardsViewControllerDelegate> delegate;

- (id)initWithCards:(ANCardSet *)theCards;


@end
