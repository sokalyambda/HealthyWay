//
//  HWChangePasswordController.m
//  HealthyWay
//
//  Created by Anastasia Mark on 02.09.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWChangePasswordController.h"

@interface HWChangePasswordController ()

@property (strong, nonatomic, readonly, nullable) IBOutletCollection(UITextField) NSArray *textFields;

@end

@implementation HWChangePasswordController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

#pragma mark - Actions

- (IBAction)performChangePasswordAction:(UIButton *)sender {
    sender.showsTouchWhenHighlighted = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textFields enumerateObjectsUsingBlock:^(UITextField  *_Nonnull currentTextField, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([currentTextField isEqual:textField]) {
            if (idx != self.textFields.count - 1) {
                NSInteger nextIndex = idx + 1;
                UITextField *nextFirstResponder = self.textFields[nextIndex];
                [nextFirstResponder becomeFirstResponder];
            } else {
                [textField resignFirstResponder];
            }
        }
    }];
    return YES;
}


@end
