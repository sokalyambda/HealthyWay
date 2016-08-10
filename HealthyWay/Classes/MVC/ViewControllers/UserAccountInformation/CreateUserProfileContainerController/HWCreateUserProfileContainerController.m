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

@property (strong, nonatomic) HWUserProfileController *userProfileController;

@end

@implementation HWCreateUserProfileContainerController

#pragma mark - Accessors

- (HWUserProfileController *)userProfileController
{
    if (!_userProfileController) {
        _userProfileController = [[HWUserProfileController alloc] init];
    }
    return _userProfileController;
}

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
    if (![self.childViewControllers containsObject:self.userProfileController]) {
        [self addChildViewController:self.userProfileController];
        [self.userProfileController didMoveToParentViewController:self];
        [self.containerView addSubview:self.userProfileController.view];
        self.userProfileController.view.frame = self.containerView.frame;
    }
}

- (IBAction)doneClick:(id)sender
{
    [self.userProfileController performCreateUpdateUser];
}

@end
