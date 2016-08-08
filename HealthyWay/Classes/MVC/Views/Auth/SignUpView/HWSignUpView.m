//
//  HWSignUpView.m
//  HealthyWay
//
//  Created by Eugene Sokolenko on 05.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWSignUpView.h"

@interface HWSignUpView ()



@end

@implementation HWSignUpView

@synthesize delegate = _delegate;

#pragma mark - Accessors

- (void)setDelegate:(id<HWAuthViewDelegate>)delegate
{
    _delegate = delegate;
    self.emailField.delegate = self.passwordField.delegate = delegate;
}

- (void)setEmail:(NSString *)email
{
//    super.email = 
}

@end
