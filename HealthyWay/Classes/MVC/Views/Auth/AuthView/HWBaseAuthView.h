//
//  HWAuthView.h
//  HealthyWay
//
//  Created by Eugene Sokolenko on 05.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWAuthTypes.h"

@protocol HWAuthViewDelegate;

/**
 *  This is the base class for authentication views: HWSignInView, HWSignUpView, HWForgotPasswordView;
 */
@interface HWBaseAuthView : UIView

@property (weak, nonatomic, nullable) id<HWAuthViewDelegate> delegate;

@property (strong, nonatomic, readonly, nonnull) NSString *email;
- (void)setEmail:(NSString *_Nonnull)email;

@property (strong, nonatomic, readonly, nullable) NSString *password;
@property (strong, nonatomic, readonly, nullable) NSString *confirmedPassword;

@property (assign, nonatomic, readonly) HWAuthType authViewType;

@property (strong, nonatomic, readonly, nullable) IBOutletCollection(UITextField) NSArray *textFields;

- (void)didCompleteAuthAction;

@end

@protocol HWAuthViewDelegate <NSObject, UITextFieldDelegate>

@optional
- (void)authView:(nullable HWBaseAuthView *)view didPrepareForAuthWithType:(HWAuthType)type;
- (void)authView:(nullable HWBaseAuthView *)view didPrepareForExchangingWithType:(HWAuthType)destinationType;

@end