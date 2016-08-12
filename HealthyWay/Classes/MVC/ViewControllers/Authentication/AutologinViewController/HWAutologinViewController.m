//
//  HWAutologinViewController.m
//  HealthyWay
//
//  Created by Eugenity on 29.06.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWAutologinViewController.h"

@interface HWAutologinViewController ()

@end

@implementation HWAutologinViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self checkForAutologin];
}

#pragma mark - Actions

- (void)performAdditionalViewControllerAdjustments
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

/*
 This methos checks up whether the autologin is needed
 */
- (void)checkForAutologin
{
    WEAK_SELF;
    [self showProgressHud];
    [HWOperationsFacade performAutologinOnSuccess:^(NSArray *users, NSString *token) {
        [weakSelf hideProgressHud];
        if (!users.count) {
            return [weakSelf performSegueWithIdentifier:@"ToUserProfileSegue" sender:self];;
        } else {
            // Show the initial controller of ChooseFlowBoard
            [weakSelf performSegueWithIdentifier:@"ChooseFlowSegue" sender:weakSelf];
        }
    } onFailure:^(NSError *error, BOOL isCancelled) {
        [weakSelf hideProgressHud];
        [weakSelf performSegueWithIdentifier:@"ToLoginZoneSegue" sender:self];
    }];
}

@end
