//
//  HWForgotPasswordView.m
//  HealthyWay
//
//  Created by Eugenity on 01.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWForgotPasswordView.h"

@interface HWForgotPasswordView ()

@property (weak, nonatomic) IBOutlet UITextField *emailField;

@end

@implementation HWForgotPasswordView

#pragma mark - Accessors

- (HWAuthType)authViewType
{
    return HWAuthTypeForgotPassword;
}

- (NSString *)email
{
    return self.emailField.text;
}

- (void)setEmail:(NSString *)email
{
    self.emailField.text = email;
}

#pragma mark - Actions

- (IBAction)backToSignInFlowClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(authView:didPrepareForExchangingWithType:)]) {
        [self.delegate authView:self didPrepareForExchangingWithType:HWAuthTypeSignIn];
    }
}

@end
