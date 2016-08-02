//
//  HWSignInView.h
//  HealthyWay
//
//  Created by Eugenity on 01.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

@protocol HWSignInViewDelegate;

@interface HWSignInView : UIView

@property (weak, nonatomic) id<HWSignInViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@protocol HWSignInViewDelegate <NSObject, UITextFieldDelegate>

@optional
- (void)signInView:(HWSignInView *)signInView didPrepareForSignInWithEmail:(NSString *)email password:(NSString *)password;
- (void)signInViewDidPrepareForExchangingWithForgotPasswordView:(HWSignInView *)signInView;

@end