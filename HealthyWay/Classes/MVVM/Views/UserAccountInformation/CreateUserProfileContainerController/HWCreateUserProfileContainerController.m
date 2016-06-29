//
//  HWCreateUserProfileContainerController.m
//  HealthyWay
//
//  Created by Eugenity on 29.06.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWCreateUserProfileContainerController.h"
#import "HWUserProfileController.h"

@interface HWCreateUserProfileContainerController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation HWCreateUserProfileContainerController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self addUserProfileControllerToContainer];
}

#pragma mark - Actions

- (void)addUserProfileControllerToContainer
{
    HWUserProfileController *controller = [[HWUserProfileController alloc] init];
    [self addChildViewController:controller];
    [controller didMoveToParentViewController:self];
    [self.containerView addSubview:controller.view];
    controller.view.frame = self.containerView.frame;
}

@end
