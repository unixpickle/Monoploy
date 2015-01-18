//
//  ANAppDelegate.h
//  Monoploy
//
//  Created by Alex Nichol on 7/16/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANMainViewController.h"

@interface ANAppDelegate : UIResponder <UIApplicationDelegate> {
    UINavigationController * navController;
}

@property (strong, nonatomic) UIWindow * window;

@end
