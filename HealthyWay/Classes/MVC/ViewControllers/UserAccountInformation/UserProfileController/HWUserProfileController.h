//
//  HWUserProfileController.h
//  HealthyWay
//
//  Created by Eugenity on 29.06.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

typedef void(^PhotoSelectionCompletion)(UIImage *chosenImage);

#import "HWBaseKeyboardHandlerViewController.h"

@interface HWUserProfileController : HWBaseKeyboardHandlerViewController

@property (copy, nonatomic) PhotoSelectionCompletion photoCompletion;

@end
