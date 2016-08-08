//
//  HWSignInView.m
//  HealthyWay
//
//  Created by Eugenity on 01.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWSignInView.h"

@interface HWSignInView ()

@property (strong, nonatomic) HWSignInView *signInView;

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation HWSignInView

@synthesize delegate = _delegate;

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

- (HWAuthViewType)authViewType
{
    return HWAuthViewTypeSignIn;
}

- (NSString *)email
{
    return self.emailField.text;
}

- (NSString *)password
{
    return self.passwordField.text;
}

- (void)setDelegate:(id<HWAuthViewDelegate>)delegate
{
    _delegate = delegate;
    self.emailField.delegate = self.passwordField.delegate = _delegate;
}

#pragma mark - Actions

- (IBAction)signInClick:(id)sender
{
    WEAK_SELF;
    [HWValidator validateEmailField:self.emailField andPasswordField:self.passwordField onSuccess:^{
        
        if ([weakSelf.delegate respondsToSelector:@selector(authView:didPrepareForAuthWithType:)]) {
            [weakSelf.delegate authView:weakSelf didPrepareForAuthWithType:weakSelf.authViewType];
        }
        
    } onFailure:^(NSMutableArray *errorArray) {
        
        if ([weakSelf.delegate isKindOfClass:[UIViewController class]]) {
            UIViewController *viewControllerForPresentingAlert = (UIViewController *)weakSelf.delegate;
            [errorArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull errDict, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *message = errDict[kValidationErrorMessage];
                [HWAlertService showAlertWithMessage:message forController:viewControllerForPresentingAlert withCompletion:nil];
            }];
        }
        [HWValidator cleanValidationErrorArray];
    }];
    
}

- (IBAction)toSignUpFlowClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(authView:didPrepareForExchangingWithType:)]) {
        [self.delegate authView:self didPrepareForExchangingWithType:HWAuthViewTypeSignUp];
    }
}

- (void)rightViewTapped:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(authView:didPrepareForExchangingWithType:)]) {
        [self.delegate authView:self didPrepareForExchangingWithType:HWAuthViewTypeForgotPassword];
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
