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

- (void)checkForAutologin
{
    [[HWBaseAppManager sharedManager].currentUser getTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
        if (error) {
            [self performSegueWithIdentifier:@"ToLoginZoneSegue" sender:self];
        }
        if (token.length) {
            [self performSegueWithIdentifier:@"ToProfileSegue" sender:self];
        }
    }];
}

@end
