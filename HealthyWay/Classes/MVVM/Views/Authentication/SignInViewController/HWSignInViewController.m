//
//  HWSignInViewController.m
//  HealthyWay
//
//  Created by Eugenity on 24.06.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWSignInViewController.h"

#import "HWBaseAppManager.h"

#import <FirebaseAuth/FirebaseAuth.h>

@interface HWSignInViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation HWSignInViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

#pragma mark - Actions

- (IBAction)confirmClick:(id)sender
{
    FIRAuth *auth = [HWBaseAppManager sharedManager].currentAuth;
    
    [HWValidator validateEmailField:self.emailField andPasswordField:self.passwordField onSuccess:^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [auth signInWithEmail:self.emailField.text password:self.passwordField.text completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (error) {
                return [HWAlertService showErrorAlert:error forController:self withCompletion:nil];
                /*
                if (error.code == 17011) {
                    [auth createUserWithEmail:self.emailField.text password:self.passwordField.text completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                        if (!error) {
                            DLog(@"User is: %@", user);
                        } else {
                            [HWAlertService showErrorAlert:error forController:self withCompletion:nil];
                        }
                    }];
                }
                 */
            }
            [self performSegueWithIdentifier:@"ToUserProfileSegue" sender:self];
            DLog(@"User: %@", user);
        }];
    } onFailure:^(NSMutableArray *errorArray) {
        [errorArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull errDict, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *message = errDict[kValidationErrorMessage];
            [HWAlertService showAlertWithMessage:message forController:self withCompletion:nil];
        }];
        [HWValidator cleanValidationErrorArray];
    }];
    
 
}


@end
