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

- (HWAuthViewType)authViewType
{
    return HWAuthViewTypeForgotPassword;
}

- (NSString *)email
{
    return self.emailField.text;
}

#pragma mark - Actions

- (IBAction)forgotPasswordClick:(id)sender
{
}

- (IBAction)backToSignInFlowClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(authView:didPrepareForExchangingWithType:)]) {
        [self.delegate authView:self didPrepareForExchangingWithType:HWAuthViewTypeSignIn];
    }
}

@end
