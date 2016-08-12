//
//  HWCreateUpdateUserProfileOperation.h
//  HealthyWay
//
//  Created by Eugenity on 10.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWBaseOperation.h"

@class HWUserProfileData;

@interface HWCreateUpdateUserProfileOperation : HWBaseOperation

@property (strong, nonatomic, readonly) HWUserProfileData *userProfileData;

- (instancetype)initWithFirstName:(NSString *)firstName
                         lastName:(NSString *)lastName
                         nickName:(NSString *)nickName
                      dateOfBirth:(NSDate *)dateOfBirth
                     avatarBase64:(NSString *)avatarBase64
                           isMale:(NSNumber *)isMalee;

@end
