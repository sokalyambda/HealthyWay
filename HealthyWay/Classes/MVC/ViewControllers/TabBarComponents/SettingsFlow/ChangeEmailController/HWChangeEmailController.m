//
//  HWChangeEmailController.m
//  HealthyWay
//
//  Created by Anastasia Mark on 23.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWChangeEmailController.h"

@interface HWChangeEmailController ()

@property (weak, nonatomic) IBOutlet UITextField *emailField;

@end

@implementation HWChangeEmailController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

#pragma mark - Actions

- (IBAction)performChangeEmailAction:(UIButton *)sender {
    sender.showsTouchWhenHighlighted = YES;
    [self showProgressHud];
    WEAK_SELF;
    [HWOperationsFacade updateUserWithEmail:self.emailField.text onSuccess:^{
        [weakSelf hideProgressHud];
        [weakSelf showAlertWithMessage:LOCALIZED(@"Your email has been changed successfully.") onCompletion:^{
            
        }];
        [self.navigationController popViewControllerAnimated:YES];
    } onFailure:^(NSError *error) {
        [weakSelf hideProgressHud];
        if (error.code == 17014) {
            [weakSelf showAlertWithError:error onCompletion:nil];
        } else if ([error.userInfo.allKeys containsObject:ErrorsArrayKey]) {
            [weakSelf showAlertViewForErrors:error.userInfo[ErrorsArrayKey]];
        } else {
            [weakSelf showAlertWithError:error onCompletion:nil];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.emailField isEqual:textField]) {
        [self.emailField resignFirstResponder];
    }
    
    return YES;
}

@end
