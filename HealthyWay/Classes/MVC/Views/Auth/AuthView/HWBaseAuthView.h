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

@interface HWBaseAuthView : UIView

@property (weak, nonatomic) id<HWAuthViewDelegate> delegate;

@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;

@property (assign, nonatomic) HWAuthViewType authViewType;

@end

@protocol HWAuthViewDelegate <NSObject, UITextFieldDelegate>

@optional
- (void)authView:(HWBaseAuthView *)view didPrepareForAuthWithType:(HWAuthViewType)type;
- (void)auhtView:(HWBaseAuthView *)view didPrepareForExchangingWithType:(HWAuthViewType)destinationType;

@end