//
//  HWSignInViewController.m
//  HealthyWay
//
//  Created by Eugenity on 24.06.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWAuthorizationViewController.h"
#import "HWSignInView.h"

#import "HWBaseAppManager.h"

#import <FirebaseAuth/FirebaseAuth.h>

#import "UIView+MakeFromXib.h"

@interface HWAuthorizationViewController ()<HWSignInViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *authViewContainer;

@property (strong, nonatomic) HWSignInView *signInView;

@end

@implementation HWAuthorizationViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self setupSignInView];
}

#pragma mark - Actions

- (void)setupSignInView
{
    self.signInView = [HWSignInView makeFromXib];
    self.signInView.delegate = self;
    self.signInView.frame = self.authViewContainer.bounds;
    [self.authViewContainer addSubview:self.signInView];
}

#pragma mark - HWSignInViewDelegate

- (void)signInView:(HWSignInView *)signInView shouldSignInWithEmail:(NSString *)email andPassword:(NSString *)password
{
    FIRAuth *auth = [HWBaseAppManager sharedManager].currentAuth;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [auth signInWithEmail:email password:password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (error) {
            return [HWAlertService showErrorAlert:error forController:self withCompletion:nil];
            /*
             if (error.code == 17011) {
             [auth createUserWithEmail:self.emailField.text password:self.passwordField.text completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
             if (!error) {
             DLog(@"User is: %@", user);
             } else {
             [HWAlertService showErrorAlert:error forController:self withCompletion:nil];
             }
             }];
             }
             */
        }
        [self performSegueWithIdentifier:@"ToUserProfileSegue" sender:self];
        DLog(@"User: %@", user);
    }];
    
}

@end
