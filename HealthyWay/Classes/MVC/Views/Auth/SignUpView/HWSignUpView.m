//
//  HWSignUpView.m
//  HealthyWay
//
//  Created by Eugene Sokolenko on 05.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWSignUpView.h"

@interface HWSignUpView ()

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;

@end

@implementation HWSignUpView

#pragma mark - Accessors

- (HWAuthType)authViewType
{
    return HWAuthTypeSignUp;
}

- (NSString *)email
{
    return self.emailField.text;
}

- (void)setEmail:(NSString *)email
{
    self.emailField.text = email;
}

- (NSString *)password
{
    return self.passwordField.text;
}

- (NSString *)confirmedPassword
{
    return self.confirmPasswordField.text;
}

#pragma mark - Actions

- (IBAction)toSignInFlowClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(authView:didPrepareForExchangingWithType:)]) {
        [self.delegate authView:self didPrepareForExchangingWithType:HWAuthTypeSignIn];
    }
}

@end
