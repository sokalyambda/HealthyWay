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

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation HWSignInView

@synthesize delegate = _delegate;
@synthesize password = _password;

#pragma mark - Accessors

- (HWAuthViewType)authViewType
{
    return HWAuthViewTypeSignIn;
}

- (NSString *)email
{
    return self.emailField.text;
}

- (NSString *)password
{
    return self.passwordField.text;
}

- (void)setDelegate:(id<HWAuthViewDelegate>)delegate
{
    _delegate = delegate;
    self.emailField.delegate = self.passwordField.delegate = _delegate;
}

#pragma mark - Actions

- (IBAction)signInClick:(id)sender
{
    WEAK_SELF;
    [HWValidator validateEmailField:self.emailField andPasswordField:self.passwordField onSuccess:^{
        
        if ([weakSelf.delegate respondsToSelector:@selector(authView:didPrepareForAuthWithType:)]) {
            [weakSelf.delegate authView:weakSelf didPrepareForAuthWithType:weakSelf.authViewType];
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

- (IBAction)toSignUpFlowClick:(id)sender
{
//    if ([self.delegate respondsToSelector:@selector(signInViewDidPrepareForExchangingWithSignUpView:)]) {
//        [self.delegate signInViewDidPrepareForExchangingWithSignUpView:self];
//    }
}

@end
