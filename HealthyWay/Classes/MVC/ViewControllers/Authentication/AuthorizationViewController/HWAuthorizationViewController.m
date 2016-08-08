//
//  HWSignInViewController.m
//  HealthyWay
//
//  Created by Eugenity on 24.06.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWAuthorizationViewController.h"

#import "HWAuthViews.h"

#import "HWBaseAppManager.h"

#import <FirebaseAuth/FirebaseAuth.h>

#import "UIView+MakeFromXib.h"

@interface HWAuthorizationViewController ()<HWAuthViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *authViewContainer;

@property (strong, nonatomic) NSArray<HWBaseAuthView *> *authViews;

@end

@implementation HWAuthorizationViewController

#pragma mark - Accessors

- (NSArray<HWBaseAuthView *> *)authViews
{
    if (!_authViews) {
        HWForgotPasswordView *forgotPasswordView = [HWForgotPasswordView makeFromXib];
        HWSignInView *signInView = [HWSignInView makeFromXib];
        HWSignUpView *signUpView = [HWSignUpView makeFromXib];
        _authViews = @[forgotPasswordView, signInView, signUpView];
        
        [_authViews setValue:self forKeyPath:@"delegate"];
    }
    return _authViews;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    //self.authViews;
//    [self setupAuthViews];
}

#pragma mark - Actions

/*
 Create and setup the sign in view from .xib
 */
- (void)setupSignInView
{
//    self.signInView = [HWSignInView makeFromXib];
//    self.signInView.delegate = self;
//    self.signInView.frame = self.authViewContainer.bounds;
//    [self.authViewContainer addSubview:self.signInView];
    
    
}

#pragma mark - HWAuthViewDelegate

- (void)authView:(HWBaseAuthView *)view didPrepareForAuthWithType:(HWAuthViewType)type
{
    FIRAuth *auth = [HWBaseAppManager sharedManager].currentAuth;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    switch (type) {
        case HWAuthViewTypeSignIn: {
            HWSignInView *signInView = (HWSignInView *)view;
            [auth signInWithEmail:signInView.email password:signInView.password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
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
            
        default:
            break;
    }
}

//#pragma mark - HWSignInViewDelegate
//
//- (void)signInView:(HWSignInView *)signInView didPrepareForSignInWithEmail:(NSString *)email password:(NSString *)password
//{
//    FIRAuth *auth = [HWBaseAppManager sharedManager].currentAuth;
//    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    
//    [auth signInWithEmail:email password:password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        if (error) {
//            return [HWAlertService showErrorAlert:error forController:self withCompletion:nil];
//            /*
//             if (error.code == 17011) {
//             [auth createUserWithEmail:self.emailField.text password:self.passwordField.text completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
//             if (!error) {
//             DLog(@"User is: %@", user);
//             } else {
//             [HWAlertService showErrorAlert:error forController:self withCompletion:nil];
//             }
//             }];
//             }
//             */
//        }
//        [self performSegueWithIdentifier:@"ToUserProfileSegue" sender:self];
//        DLog(@"User: %@", user);
//    }];
//    
//}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    if (textField == self.signInView.emailField) {
//        [self.signInView.passwordField becomeFirstResponder];
//    } else {
//        [textField resignFirstResponder];
//    }
    
    return YES;
}

@end
