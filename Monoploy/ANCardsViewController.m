//
//  ANCardsViewController.m
//  Monoploy
//
//  Created by Alex Nichol on 7/19/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANCardsViewController.h"

@interface ANCardsViewController ()

@end

@implementation ANCardsViewController

@synthesize cards;
@synthesize delegate;

- (id)initWithCards:(ANCardSet *)theCards {
    if ((self = [super initWithStyle:UITableViewStylePlain])) {
        cards = theCards;
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [@[@"Unordered", @"Ordered (Bottom)"] objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return [cards.unorderedCards count];
    return [cards.orderedCards count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:@"Cell"];
    }
    ANCard * card = nil;
    if (indexPath.section == 0) {
        card = [cards.unorderedCards objectAtIndex:indexPath.row];
    } else {
        card = [cards.orderedCards objectAtIndex:indexPath.row];
    }
    cell.textLabel.text = [card title];
    cell.detailTextLabel.text = [card subtitle];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        [tableView beginUpdates];
        NSInteger rowDest = [self.cards.orderedCards count];
        NSIndexPath * destIndex = [NSIndexPath indexPathForRow:rowDest inSection:1];
        [tableView moveRowAtIndexPath:indexPath toIndexPath:destIndex];
        
        ANCard * draw = [self.cards.unorderedCards objectAtIndex:indexPath.row];
        cards = [cards cardSetByDrawing:draw];
        [delegate cardsViewControllerChanged:self];
        [tableView endUpdates];
    } else {
        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"What would you like to do"
                                                            delegate:self
                                                   cancelButtonTitle:@"Cancel"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"Move to Unordered",
                                                                     @"Move to Bottom", nil];
        [sheet showInView:self.view];
        selectedIndex = indexPath;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.tableView deselectRowAtIndexPath:selectedIndex animated:YES];
    NSString * title = [actionSheet buttonTitleAtIndex:buttonIndex];
    NSIndexPath * destPath = nil;
    ANCardSet * newCards = nil;
    ANCard * drawn = [cards.orderedCards objectAtIndex:selectedIndex.row];
    if ([title isEqualToString:@"Move to Unordered"]) {
        newCards = [cards cardSetByUndrawinng:drawn];
        NSInteger index = [newCards.unorderedCards indexOfObject:drawn];
        destPath = [NSIndexPath indexPathForRow:index inSection:0];
    } else if ([title isEqualToString:@"Move to Bottom"]) {
        newCards = [cards cardSetByDrawing:drawn];
        NSInteger index = [newCards.orderedCards indexOfObject:drawn];
        destPath = [NSIndexPath indexPathForRow:index inSection:1];
    } else {
        return;
    }
    [self.tableView beginUpdates];
    cards = newCards;
    [delegate cardsViewControllerChanged:self];
    [self.tableView moveRowAtIndexPath:selectedIndex toIndexPath:destPath];
    [self.tableView endUpdates];
}

@end
