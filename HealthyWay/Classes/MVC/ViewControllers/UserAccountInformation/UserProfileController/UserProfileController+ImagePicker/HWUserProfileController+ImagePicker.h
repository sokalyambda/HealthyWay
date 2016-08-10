//
//  HWUserProfileController+ImagePicker.h
//  HealthyWay
//
//  Created by Eugenity on 10.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWUserProfileController.h"

@interface HWUserProfileController (ImagePicker) 

- (void)presentChangePhotoActionSheetWithCompletion:(PhotoSelectionCompletion)completion;

@end
