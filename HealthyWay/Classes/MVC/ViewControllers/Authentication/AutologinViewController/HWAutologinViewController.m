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
    FIRUser *user = [HWBaseAppManager sharedManager].currentUser;
    if (user) {
        WEAK_SELF;
        [[HWBaseAppManager sharedManager].currentUser getTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
            if (token.length) {
                
                [weakSelf showProgressHud];
                
                [HWOperationsFacade fetchUsersWithFetchingType:HWFetchUsersOperationTypeCurrent onSuccess:^(NSArray *users) {
                    
                    [weakSelf hideProgressHud];
                    if (!users.count) {
                        return [weakSelf performSegueWithIdentifier:@"ToUserProfileSegue" sender:self];;
                    } else {
                        // Show the initial controller of ChooseFlowBoard
                        [weakSelf performSegueWithIdentifier:@"ChooseFlowSegue" sender:weakSelf];
                    }
                    
                } onFailure:^(NSError *error, BOOL isCancelled) {
                    
                    [weakSelf hideProgressHud];
                    
                }];
                
            } else {
                [self performSegueWithIdentifier:@"ToLoginZoneSegue" sender:self];
            }
        }];
        
    } else {
        [self performSegueWithIdentifier:@"ToLoginZoneSegue" sender:self];
    }
    
}

@end
