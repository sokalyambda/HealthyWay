//
//  HWCreateUpdateUserProfileTask.h
//  HealthyWay
//
//  Created by Eugenity on 15.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

@class HWUserProfileData;

#import "HWBaseTask.h"

@interface HWCreateUpdateUserProfileTask : HWBaseTask

@property (strong, nonatomic, readonly) HWUserProfileData *userProfileData;

- (instancetype)initWithFirstName:(NSString *)firstName
                         lastName:(NSString *)lastName
                         nickName:(NSString *)nickName
                      dateOfBirth:(NSDate *)dateOfBirth
                     avatarBase64:(NSString *)avatarBase64
                           isMale:(NSNumber *)isMale;

@end
