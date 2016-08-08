//
//  HWSignUpView.m
//  HealthyWay
//
//  Created by Eugene Sokolenko on 05.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWSignUpView.h"

@interface HWSignUpView ()

@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;

@end

@implementation HWSignUpView

#pragma mark - Accessors

- (HWAuthViewType)authViewType
{
    return HWAuthViewTypeSignUp;
}

- (void)setDelegate:(id<HWAuthViewDelegate>)delegate
{
    [super setDelegate:delegate];
    self.confirmPasswordField.delegate = delegate;
}

#pragma mark - Actions

- (IBAction)toSignInFlowClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(authView:didPrepareForExchangingWithType:)]) {
        [self.delegate authView:self didPrepareForExchangingWithType:HWAuthViewTypeSignIn];
    }
}


@end
