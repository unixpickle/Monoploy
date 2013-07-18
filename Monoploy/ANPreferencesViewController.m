//
//  ANPreferencesViewController.m
//  Monoploy
//
//  Created by Alex Nichol on 7/18/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANPreferencesViewController.h"

@interface ANPreferencesViewController ()

@end

@implementation ANPreferencesViewController

- (id)init {
    if ((self = [super init])) {
        self.title = @"Preferences";
        
        compoundProbabilities = [[UISegmentedControl alloc] initWithItems:@[@"Finishing At", @"Landing On"]];
        compoundProbabilities.frame = CGRectMake(10, 40, 300, 44);
        compoundProbabilities.selectedSegmentIndex = [[ANPreferences sharedPreferences] compoundTurns];
        
        UILabel * compoundLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 300, 20)];
        compoundLabel.backgroundColor = [UIColor clearColor];
        compoundLabel.text = @"Report the chances of";
        compoundLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:compoundLabel];
        [self.view addSubview:compoundProbabilities];
        
        finderType = [[UISegmentedControl alloc] initWithItems:@[@"Markov Chains", @"Recursion"]];
        finderType.frame = CGRectMake(10, 135, 300, 44);
        finderType.selectedSegmentIndex = [[ANPreferences sharedPreferences] finderType];
        
        UILabel * finderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, 300, 20)];
        finderLabel.backgroundColor = [UIColor clearColor];
        finderLabel.text = @"Internal computation mechanism";
        finderLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:finderType];
        [self.view addSubview:finderLabel];
        
        jailScheme = [[UISegmentedControl alloc] initWithItems:@[@"Immediate", @"Doubles Only"]];
        jailScheme.frame = CGRectMake(10, 230, 300, 44);
        jailScheme.selectedSegmentIndex = [[ANPreferences sharedPreferences] jailOnlyDoubles];
        
        UILabel * jailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 205, 300, 20)];
        jailLabel.backgroundColor = [UIColor clearColor];
        jailLabel.text = @"Jail escape scheme";
        jailLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:jailScheme];
        [self.view addSubview:jailLabel];
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [[ANPreferences sharedPreferences] setCompoundTurns:compoundProbabilities.selectedSegmentIndex];
    [[ANPreferences sharedPreferences] setJailOnlyDoubles:jailScheme.selectedSegmentIndex];
    [[ANPreferences sharedPreferences] setFinderType:finderType.selectedSegmentIndex];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
