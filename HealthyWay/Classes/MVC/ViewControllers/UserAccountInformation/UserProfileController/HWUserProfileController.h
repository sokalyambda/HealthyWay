//
//  HWUserProfileController.h
//  HealthyWay
//
//  Created by Eugenity on 29.06.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

typedef void(^PhotoSelectionCompletion)(UIImage *chosenImage);

@protocol HWUserProfileControllerDelegate;

#import "HWBaseKeyboardHandlerViewController.h"

@interface HWUserProfileController : HWBaseKeyboardHandlerViewController

@property (weak, nonatomic) id<HWUserProfileControllerDelegate> delegate;

@property (copy, nonatomic) PhotoSelectionCompletion photoCompletion;

- (void)performCreateUpdateUser;

@end

@protocol HWUserProfileControllerDelegate <NSObject>

@optional
- (void)userProfileControllerDidUpdateUser:(HWUserProfileController *)controller;

@end