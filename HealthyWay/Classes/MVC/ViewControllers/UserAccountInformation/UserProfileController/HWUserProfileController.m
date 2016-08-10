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

@interface HWUserProfileController ()<HWBirthDatePickerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImageView;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *nickNameField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentedControl;
@property (weak, nonatomic) IBOutlet UITextField *birthDateField;

@end

@implementation HWUserProfileController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupBirthDatePicker];
    [self setupTapForUserAvatarImageView];
}

#pragma mark - Actions

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

#pragma mark - HWBirthDatePickerDelegate

- (void)birthDatePicker:(HWBirthDatePicker *)picker didSelectDate:(NSDate *)aDate
{
    self.birthDateField.text = [[HWCommonDateFormatter commonDateFormatter] stringFromDate:aDate];
}

- (void)birthDatePickerDidClickDoneButton:(HWBirthDatePicker *)picker
{
    [self.birthDateField resignFirstResponder];
}

@end
