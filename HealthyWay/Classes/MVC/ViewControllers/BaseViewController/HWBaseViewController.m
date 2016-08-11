//
//  BaseViewController.m
//  HealthyWay
//
//  Created by Eugenity on 24.06.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWBaseViewController.h"

#import "NSString+ErrorString.h"

@interface HWBaseViewController ()

@end

@implementation HWBaseViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self performAdditionalViewControllerAdjustments];
}

#pragma mark - Actions

/**
 *  Abstract method
 */
- (void)performAdditionalViewControllerAdjustments
{
    return;
}

/**
 *  Show the alert view for array of errors
 *
 *  @param errors Array of dictionaries which contains error messages.
 */
- (void)showAlertViewForErrors:(NSArray *)errors
{
    NSString *message = [NSString errorStringFromErrorsArray:errors];
    [HWAlertService showAlertWithMessage:message forController:self withCompletion:nil];
}

@end
