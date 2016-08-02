//
//  HWAutologinViewController.m
//  HealthyWay
//
//  Created by Eugenity on 29.06.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWAutologinViewController.h"

#import "HWBaseAppManager.h"

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

/*
 This methos checks up whether the autologin is needed
 */
- (void)checkForAutologin
{
    FIRUser *user = [HWBaseAppManager sharedManager].currentUser;
    if (user) {
        [[HWBaseAppManager sharedManager].currentUser getTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
            if (token.length) {
                [self performSegueWithIdentifier:@"ToProfileSegue" sender:self];
            } else {
                [self performSegueWithIdentifier:@"ToLoginZoneSegue" sender:self];
            }
        }];
    } else {
        [self performSegueWithIdentifier:@"ToLoginZoneSegue" sender:self];
    }
}

@end
