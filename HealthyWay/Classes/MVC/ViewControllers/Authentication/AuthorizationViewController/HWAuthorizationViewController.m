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

static const NSInteger kUserDoesNotExist = 17011;

@interface HWAuthorizationViewController ()<HWAuthViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *authViewContainer;

@property (strong, nonatomic) HWBaseAuthView *currentAuthView;

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
    [self setupAuthViewWithType:HWAuthTypeSignIn];
}

#pragma mark - Private

- (void)performAdditionalViewControllerAdjustments
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

/*
 Create and setup the sign in view from .xib
 */
- (void)setupAuthViewWithType:(HWAuthType)authViewType
{
    HWBaseAuthView *neededAuthView;
    HWBaseAuthView *currentAuthView;
    
    if (!!self.authViewContainer.subviews.count) {
        NSAssert1([self.authViewContainer.subviews[0] isKindOfClass:[HWBaseAuthView class]], @"View %@ is not kind of class HWBaseAuthView", self.authViewContainer.subviews[0]);
        currentAuthView = self.authViewContainer.subviews[0];
    }

    switch (authViewType) {
        case HWAuthTypeSignIn: {
            neededAuthView = self.authViews[1]; //In out auth views stack the sign in view placed in the middle
            break;
        }
        case HWAuthTypeSignUp: {
            neededAuthView = self.authViews[2]; //Sign up view is the last view in stack
            break;
        }
        case HWAuthTypeForgotPassword: {
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

#pragma mark - HWAuthViewDelegate

- (void)authView:(HWBaseAuthView *)view didPrepareForAuthWithType:(HWAuthType)type
{
    [self showProgressHud];
    WEAK_SELF;
    [HWOperationsFacade performAuthorizationProcessWithEmail:view.email password:view.password confirmedPassword:view.confirmedPassword authType:type onSuccess:^ {
        switch (type) {
            case HWAuthTypeSignIn: {
                
                [HWOperationsFacade fetchUsersWithFetchingType:HWFetchUsersTaskTypeCurrent onSuccess:^(NSArray *users) {
                    [weakSelf hideProgressHud];
                    if (!users.count) {
                        [weakSelf performSegueWithIdentifier:@"ToUserProfileSegue" sender:self];
                        return [view didCompleteAuthAction];
                    } else {
                        // Show the initial controller of ChooseFlowBoard
                        [weakSelf performSegueWithIdentifier:@"ChooseFlowSegue" sender:weakSelf];
                    }
                } onFailure:^(NSError *error, BOOL isCancelled) {
                    [weakSelf hideProgressHud];
                }];
                break;
            }
            case HWAuthTypeSignUp: {
                [weakSelf hideProgressHud];
                [weakSelf performSegueWithIdentifier:@"ToUserProfileSegue" sender:self];
                return [view didCompleteAuthAction];
            }
            case HWAuthTypeForgotPassword: {
                [weakSelf hideProgressHud];
                
                [weakSelf showAlertWithMessage:LOCALIZED(@"Your password has been reset successfully.\nPlease, check your email to set new password.") onCompletion:^{
                    [weakSelf setupAuthViewWithType:HWAuthTypeSignIn];
                    [weakSelf.currentAuthView setEmail:view.email];
                    return [view didCompleteAuthAction];
                }];
            }
        }
    } onFailure:^(NSError *error, BOOL isCancelled) {
        [weakSelf hideProgressHud];
        
        if (error.code == kUserDoesNotExist) {
            // Move to sign up flow if user doesn't exist;
            [weakSelf setupAuthViewWithType:HWAuthTypeSignUp];
            HWSignUpView *signUpView = (HWSignUpView *)weakSelf.authViews[2];
            [signUpView setEmail:view.email];
            [view didCompleteAuthAction];
        } else if ([error.userInfo.allKeys containsObject:ErrorsArrayKey]) {
            [weakSelf showAlertViewForErrors:error.userInfo[ErrorsArrayKey]];
        } else {
            [weakSelf showAlertWithError:error onCompletion:nil];
        }
    }];
}

- (void)authView:(nullable HWBaseAuthView *)view didPrepareForExchangingWithType:(HWAuthType)destinationType
{
    switch (destinationType) {
        case HWAuthTypeSignUp:
            return [self setupAuthViewWithType:HWAuthTypeSignUp];
        case HWAuthTypeSignIn:
            return [self setupAuthViewWithType:HWAuthTypeSignIn];
        case HWAuthTypeForgotPassword:
            return [self setupAuthViewWithType:HWAuthTypeForgotPassword];
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
