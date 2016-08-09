//
//  HWSignInView.m
//  HealthyWay
//
//  Created by Eugenity on 01.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWSignInView.h"

@interface HWSignInView ()

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation HWSignInView

#pragma mark - Lifecycle

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self commonInit];
}

#pragma mark - Accessors

- (HWAuthType)authViewType
{
    return HWAuthTypeSignIn;
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

#pragma mark - Actions

- (IBAction)toSignUpFlowClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(authView:didPrepareForExchangingWithType:)]) {
        [self.delegate authView:self didPrepareForExchangingWithType:HWAuthTypeSignUp];
    }
}

- (void)rightViewTapped:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(authView:didPrepareForExchangingWithType:)]) {
        [self.delegate authView:self didPrepareForExchangingWithType:HWAuthTypeForgotPassword];
    }
}

- (void)commonInit
{
    if ([self isMemberOfClass:[HWSignInView class]]) {

        CGFloat neededHeight = CGRectGetHeight(self.passwordField.frame) * .8f;
        UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, neededHeight, neededHeight)];
        rightImageView.image = [UIImage imageNamed:@"question_mark_icon"];
        
        rightImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *rightViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightViewTapped:)];
        [rightImageView addGestureRecognizer:rightViewTap];
        [rightImageView setContentMode:UIViewContentModeScaleAspectFit];
        
        self.passwordField.rightView = rightImageView;
        
        self.passwordField.rightViewMode = UITextFieldViewModeAlways;
    }
}

@end
