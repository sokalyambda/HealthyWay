//
//  HWUserProfileController.m
//  HealthyWay
//
//  Created by Eugenity on 29.06.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWUserProfileController.h"

#import "HWBirthDatePicker.h"

#import "HWCommonDateFormatter.h"

#import "UIView+MakeFromXib.h"
#import "HWUserProfileController+ImagePicker.h"
#import "UIImage+EncodeToBase64.h"

@interface HWUserProfileController ()<HWBirthDatePickerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImageView;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *nickNameField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentedControl;
@property (weak, nonatomic) IBOutlet UITextField *birthDateField;

@property (strong, nonatomic) NSDate *dateOfBirth;

@end

@implementation HWUserProfileController

#pragma mark - Accessors

- (void)setDateOfBirth:(NSDate *)dateOfBirth
{
    _dateOfBirth = dateOfBirth;
    self.birthDateField.text = [[HWCommonDateFormatter commonDateFormatter] stringFromDate:dateOfBirth];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupBirthDatePicker];
    [self setupTapForUserAvatarImageView];
}

#pragma mark - Actions

- (void)performAdditionalViewControllerAdjustments
{
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(performCreateUpdateUser)];
    self.parentViewController.navigationItem.rightBarButtonItem = doneButton;
}

/**
 *  Setup the custom date picker as the input view of birthDateField
 */
- (void)setupBirthDatePicker
{
    HWBirthDatePicker *birthDatePicker = [HWBirthDatePicker makeFromXib];
    birthDatePicker.delegate = self;
    self.birthDateField.inputView = birthDatePicker;
}

- (void)presentImagePickerActionSheet
{
    WEAK_SELF;
    [self presentChangePhotoActionSheetWithCompletion:^(UIImage *chosenImage) {
        weakSelf.userAvatarImageView.image = chosenImage;
    }];
}

/**
 *  Setup gesture to the image view and use category for other work;
 */
- (void)setupTapForUserAvatarImageView
{
    UITapGestureRecognizer *avatarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(presentImagePickerActionSheet)];
    self.userAvatarImageView.userInteractionEnabled = YES;
    [self.userAvatarImageView addGestureRecognizer:avatarTap];
}

- (void)performCreateUpdateUser
{
    if ([self.delegate respondsToSelector:@selector(userProfileController:didPrepareUpdWithFirstName:lastName:nickName:dateOfBirth:avatarBase64:isMale:)]) {
        [self.delegate userProfileController:self
                  didPrepareUpdWithFirstName:self.firstNameField.text
                                    lastName:self.lastNameField.text
                                    nickName:self.nickNameField.text
                                 dateOfBirth:self.dateOfBirth
                                avatarBase64:[self.userAvatarImageView.image encodeToBase64String]
                                      isMale:@(self.genderSegmentedControl.selectedSegmentIndex)];
    }
}

#pragma mark - HWBirthDatePickerDelegate

- (void)birthDatePicker:(HWBirthDatePicker *)picker didSelectDate:(NSDate *)aDate
{
    self.dateOfBirth = aDate;
}

- (void)birthDatePickerDidClickDoneButton:(HWBirthDatePicker *)picker
{
    [self.birthDateField resignFirstResponder];
}

@end
