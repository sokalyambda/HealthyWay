//
//  HWCreateUserProfileContainerController.m
//  HealthyWay
//
//  Created by Eugenity on 29.06.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWCreateUserProfileContainerController.h"
#import "HWUserProfileController.h"

@interface HWCreateUserProfileContainerController ()<HWUserProfileControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) HWUserProfileController *userProfileController;

@end

@implementation HWCreateUserProfileContainerController

#pragma mark - Accessors

- (HWUserProfileController *)userProfileController
{
    if (!_userProfileController) {
        _userProfileController = [[HWUserProfileController alloc] init];
        _userProfileController.delegate = self;
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

#pragma mark - HWUserProfileControllerDelegate

- (void)didUpdateUser
{
    [self.navigationController setNavigationBarHidden:YES
                                             animated:YES];
    [self performSegueWithIdentifier:@"ChooseFlowSegue" sender:self];
}

- (void)userProfileController:(HWUserProfileController *)controller
   didPrepareUpdWithFirstName:(NSString *)firstName
                     lastName:(NSString *)lastName
                     nickName:(NSString *)nickName
                  dateOfBirth:(NSDate *)dateOfBirth
                 avatarBase64:(NSString *)avatarBase64
                       isMale:(NSNumber *)isMale
{
    WEAK_SELF;
    [self showProgressHud];
    
    [HWOperationsFacade createUpdateUserWithFirstName:firstName
                                             lastName:lastName
                                             nickName:nickName
                                          dateOfBirth:dateOfBirth
                                         avatarBase64:avatarBase64
                                               isMale:isMale onSuccess:^ {
                                                   [weakSelf hideProgressHud];
                                                   [weakSelf didUpdateUser];
                                               } onFailure:^(NSError *error, BOOL isCancelled) {
                                                   [weakSelf hideProgressHud];
                                                   
                                                   if ([error.userInfo.allKeys containsObject:ErrorsArrayKey]) {
                                                       return [weakSelf showAlertViewForErrors:error.userInfo[ErrorsArrayKey]];
                                                   }
                                                   [weakSelf showAlertWithError:error onCompletion:nil];
                                               }];
}

@end
