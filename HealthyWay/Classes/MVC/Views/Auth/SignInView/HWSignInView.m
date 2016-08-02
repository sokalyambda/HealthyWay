//
//  HWSignInView.m
//  HealthyWay
//
//  Created by Eugenity on 01.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWSignInView.h"

@interface HWSignInView ()

@property (strong, nonatomic) HWSignInView *signInView;

@end

@implementation HWSignInView

#pragma mark - Accessors

- (void)setDelegate:(id<HWSignInViewDelegate>)delegate
{
    _delegate = delegate;
    self.emailField.delegate = self.passwordField.delegate = _delegate;
}

#pragma mark - Actions

- (IBAction)signInClick:(id)sender {
    WEAK_SELF;
    [HWValidator validateEmailField:self.emailField andPasswordField:self.passwordField onSuccess:^{
        
        if ([weakSelf.delegate respondsToSelector:@selector(signInView:didPrepareForSignInWithEmail:password:)]) {
            [weakSelf.delegate signInView:weakSelf didPrepareForSignInWithEmail:self.emailField.text password:self.passwordField.text];
        }
        
    } onFailure:^(NSMutableArray *errorArray) {
        
        if ([weakSelf.delegate isKindOfClass:[UIViewController class]]) {
            UIViewController *viewControllerForPresentingAlert = (UIViewController *)weakSelf.delegate;
            [errorArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull errDict, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *message = errDict[kValidationErrorMessage];
                [HWAlertService showAlertWithMessage:message forController:viewControllerForPresentingAlert withCompletion:nil];
            }];
        }
        [HWValidator cleanValidationErrorArray];
    }];
    
}

- (IBAction)toSignUpFlowClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(signInViewDidPrepareForExchangingWithForgotPasswordView:)]) {
        [self.delegate signInViewDidPrepareForExchangingWithForgotPasswordView:self];
    }
}

@end
