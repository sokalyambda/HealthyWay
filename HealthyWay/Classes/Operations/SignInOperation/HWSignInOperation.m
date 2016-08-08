//
//  HWSignInOperation.m
//  HealthyWay
//
//  Created by Eugene Sokolenko on 08.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWSignInOperation.h"

#import "HWBaseViewController.h"

@interface HWSignInOperation ()

@property (strong, nonatomic) FIRAuth *currentAuth;

@end

@implementation HWSignInOperation

#pragma mark - Accessors

- (FIRAuth *)currentAuth
{
    return [HWBaseAppManager sharedManager].currentAuth;
}

#pragma mark - Lifecycle

- (instancetype)initWithViewController:(HWBaseViewController *)viewController
                                 email:(NSString *)email
                              password:(NSString *)password
{
    self = [super init];
    if (self) {
        _email = email;
        _password = password;
        _viewController = viewController;
        
        [self willChangeValueForKey:@"ready"];
        [self setValue:@YES forKey:@"ready"];
        [self didChangeValueForKey:@"ready"];
    }
    return self;
}

- (void)main
{
    /*
     if (error) {
     if (error.code == kUserDoesNotExist) {
     // Move to sign up flow if user doesn't exist;
     [weakSelf setupAuthViewWithType:HWAuthViewTypeSignUp];
     HWSignUpView *signUpView = (HWSignUpView *)weakSelf.authViews[2];
     [signUpView setEmail:view.email];
     [view didCompleteAuthAction];
     } else {
     return [HWAlertService showErrorAlert:error forController:self withCompletion:nil];
     }
     } else {
     [view didCompleteAuthAction];
     [self performSegueWithIdentifier:@"ToUserProfileSegue" sender:self];
     DLog(@"User: %@", user);
     }
     */
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
    [HWValidator validateEmail:self.email andPassword:self.password onSuccess:^{
        [self.currentAuth signInWithEmail:weakSelf.email password:weakSelf.password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
            
            /**
             *  We have to guarantee that UI things will be performed on the main thread;
             */
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:weakSelf.viewController.view animated:YES];
                
            });
        }];
    } onFailure:^(NSMutableArray *errorArray) {
        
    }];
}
@end
