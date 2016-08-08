//
//  HWAuthView.h
//  HealthyWay
//
//  Created by Eugene Sokolenko on 05.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

typedef enum : NSUInteger {
    HWAuthViewTypeSignIn,
    HWAuthViewTypeSignUp,
    HWAuthViewTypeForgotPassword,
} HWAuthViewType;

@protocol HWAuthViewDelegate;

/**
 *  This is the base class for authentication views: HWSignInView, HWSignUpView, HWForgotPasswordView;
 */
@interface HWBaseAuthView : UIView

@property (weak, nonatomic, nullable) id<HWAuthViewDelegate> delegate;

@property (strong, nonatomic, nonnull) NSString *email;
@property (strong, nonatomic, nullable) NSString *password;
@property (strong, nonatomic, nullable) NSString *confirmedPassword;

@property (assign, nonatomic) HWAuthViewType authViewType;

@end

@protocol HWAuthViewDelegate <NSObject, UITextFieldDelegate>

@optional
- (void)authView:(nullable HWBaseAuthView *)view didPrepareForAuthWithType:(HWAuthViewType)type;
- (void)authView:(nullable HWBaseAuthView *)view didPrepareForExchangingWithType:(HWAuthViewType)destinationType;

@end