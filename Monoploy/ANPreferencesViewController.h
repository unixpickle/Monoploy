//
//  ANPreferencesViewController.h
//  Monoploy
//
//  Created by Alex Nichol on 7/18/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANPreferences.h"

@interface ANPreferencesViewController : UIViewController {
    UISegmentedControl * compoundProbabilities;
    UISegmentedControl * finderType;
    UISegmentedControl * jailScheme;
}

@end
