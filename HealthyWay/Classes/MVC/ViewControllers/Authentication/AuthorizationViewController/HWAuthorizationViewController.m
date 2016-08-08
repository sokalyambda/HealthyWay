//
//  HWSignInViewController.m
//  HealthyWay
//
//  Created by Eugenity on 24.06.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWAuthorizationViewController.h"

#import "HWAuthViews.h"

#import <FirebaseAuth/FirebaseAuth.h>

#import "UIView+MakeFromXib.h"
#import "HWAuthorizationViewController+AuthViewTransitionSubtype.h"
#import "CAAnimation+CompletionBlock.h"
#import "NSString+ErrorString.h"

static const NSInteger kUserDoesNotExist = 17011;

@interface HWAuthorizationViewController ()<HWAuthViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *authViewContainer;

@property (strong, nonatomic) NSArray<HWBaseAuthView *> *authViews;

@property (strong, nonatomic) HWBaseAuthView *currentAuthView;

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
        
        if ([self conformsToProtocol:@protocol(HWAuthViewDelegate)]) {
           [_authViews setValue:self forKeyPath:@"delegate"];
        }
    }
    return _authViews;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // By default, the first visible view is sign in view. Show it.
    [self setupAuthViewWithType:HWAuthViewTypeSignIn];
}

#pragma mark - Private

- (void)performAdditionalViewControllerAdjustments
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

/*
 Create and setup the sign in view from .xib
 */
- (void)setupAuthViewWithType:(HWAuthViewType)authViewType
{
    HWBaseAuthView *neededAuthView;
    HWBaseAuthView *currentAuthView;
    
    if (!!self.authViewContainer.subviews.count) {
        NSAssert1([self.authViewContainer.subviews[0] isKindOfClass:[HWBaseAuthView class]], @"View %@ is not kind of class HWBaseAuthView", self.authViewContainer.subviews[0]);
        currentAuthView = self.authViewContainer.subviews[0];
    }

    switch (authViewType) {
        case HWAuthViewTypeSignIn: {
            neededAuthView = self.authViews[1]; //In out auth views stack the sign in view placed in the middle
            break;
        }
        case HWAuthViewTypeSignUp: {
            neededAuthView = self.authViews[2]; //Sign up view is the last view in stack
            break;
        }
        case HWAuthViewTypeForgotPassword: {
            neededAuthView = self.authViews[0]; //Forgot password view is the first view in stack
            break;
        }
    }
    
    neededAuthView.frame = self.authViewContainer.bounds;
    [self.authViewContainer addSubview:neededAuthView];
    
    // Set the current auth view:
    self.currentAuthView = neededAuthView;
    
    CATransition *transition = [self showView:neededAuthView insteadOfView:currentAuthView];
    
    transition.begin = ^void() {
        self.view.userInteractionEnabled = NO;
    };
    
    transition.end = ^void(BOOL end) {
        self.view.userInteractionEnabled = YES;
        [currentAuthView removeFromSuperview];
    };
}

- (CATransition *)showView:(HWBaseAuthView *)destinationView
             insteadOfView:(HWBaseAuthView *)sourceView
{
    if (!sourceView) {
        return nil;
    }
    //Animate the switching of title imageView/label
    CATransition *transition = [CATransition animation];
    transition.startProgress = 0.f;
    transition.endProgress = 1.f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = [self authViewTransitionSubtypeForSourceAuthViewType:sourceView.authViewType destinationType:destinationView.authViewType];
    transition.duration = .3f;
    
    // Add the transition animation to both layers
    [destinationView.layer addAnimation:transition forKey:@"transition"];
    [sourceView.layer addAnimation:transition forKey:@"transition"];
    
    sourceView.hidden = YES;
    destinationView.hidden = !sourceView.isHidden;
    
    return transition;
}

/**
 *  Show the alert view for array of errors
 *
 *  @param errors Array of dictionaries which contain error messages.
 */
- (void)showAlertViewForErrors:(NSArray *)errors
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSString *message = [NSString errorStringFromErrorsArray:errors];
    
    [HWAlertService showAlertWithMessage:message forController:self withCompletion:^{
        [HWValidator cleanValidationErrorArray];
    }];
}

#pragma mark - HWAuthViewDelegate

- (void)authView:(HWBaseAuthView *)view didPrepareForAuthWithType:(HWAuthViewType)type
{
    FIRAuth *auth = [HWBaseAppManager sharedManager].currentAuth;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    WEAK_SELF;
    
    switch (type) {
        case HWAuthViewTypeSignIn: {
            [HWValidator validateEmail:view.email andPassword:view.password onSuccess:^{
                [auth signInWithEmail:view.email password:view.password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                    
                    /**
                     *  We have to guarantee that UI things will be performed on the main thread;
                     */
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                        if (error) {
                            if (error.code == kUserDoesNotExist) {
                                // Move to sign up flow if user doesn't exist;
                                [weakSelf setupAuthViewWithType:HWAuthViewTypeSignUp];
                                HWSignUpView *signUpView = (HWSignUpView *)weakSelf.authViews[2];
                                [signUpView setEmail:view.email];
                            } else {
                                return [HWAlertService showErrorAlert:error forController:self withCompletion:nil];
                            }
                        } else {
                            [view didCompleteAuthAction];
                            [self performSegueWithIdentifier:@"ToUserProfileSegue" sender:self];
                            DLog(@"User: %@", user);
                        }
                    });
                }];
            } onFailure:^(NSMutableArray *errorArray) {
                [self showAlertViewForErrors:errorArray];
            }];
            break;
        }
        case HWAuthViewTypeSignUp: {
            [HWValidator validateEmail:view.email andPassword:view.password andConfirmPassword:view.confirmedPassword onSuccess:^{
                
                [auth createUserWithEmail:view.email password:view.password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        if (!error) {
                            DLog(@"User is: %@", user);
                            [view didCompleteAuthAction];
                            [weakSelf performSegueWithIdentifier:@"ToUserProfileSegue" sender:self];
                        } else {
                            [HWAlertService showErrorAlert:error forController:self withCompletion:nil];
                        }
                    });
                    
                }];
                
            } onFailure:^(NSMutableArray *errorArray) {
                [self showAlertViewForErrors:errorArray];
            }];
            break;
        }
        case HWAuthViewTypeForgotPassword: {
            [HWValidator validateEmail:view.email onSuccess:^{
                [auth sendPasswordResetWithEmail:view.email completion:^(NSError * _Nullable error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        if (error) {
                            [HWAlertService showErrorAlert:error forController:self withCompletion:nil];
                        } else {
                            [HWAlertService showAlertWithMessage:LOCALIZED(@"Your password has been reset successfully.\nPlease, check your email to set new password.") forController:weakSelf withCompletion:^{
                                [view didCompleteAuthAction];
                                [weakSelf setupAuthViewWithType:HWAuthViewTypeSignIn];
                            }];
                        }
                    });
                }];
            } onFailure:^(NSMutableArray *errorArray) {
                [self showAlertViewForErrors:errorArray];
            }];
            break;
        }
    }
}

- (void)authView:(nullable HWBaseAuthView *)view didPrepareForExchangingWithType:(HWAuthViewType)destinationType
{
    switch (destinationType) {
        case HWAuthViewTypeSignUp:
            return [self setupAuthViewWithType:HWAuthViewTypeSignUp];
        case HWAuthViewTypeSignIn:
            return [self setupAuthViewWithType:HWAuthViewTypeSignIn];
        case HWAuthViewTypeForgotPassword:
            return [self setupAuthViewWithType:HWAuthViewTypeForgotPassword];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.currentAuthView.textFields enumerateObjectsUsingBlock:^(UITextField  *_Nonnull authTextField, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([authTextField isEqual:textField]) {
            if (idx != self.currentAuthView.textFields.count - 1) {
                NSInteger nextIndex = idx + 1;
                UITextField *nextFirstResponder = self.currentAuthView.textFields[nextIndex];
                [nextFirstResponder becomeFirstResponder];
            } else {
                [textField resignFirstResponder];
            }
        }
    }];
    return YES;
}

@end
