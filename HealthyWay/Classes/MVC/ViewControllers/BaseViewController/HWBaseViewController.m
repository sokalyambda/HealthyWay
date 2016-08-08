//
//  BaseViewController.m
//  HealthyWay
//
//  Created by Eugenity on 24.06.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWBaseViewController.h"

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

@end
