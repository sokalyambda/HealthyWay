//
//  HWUserProfileData.h
//  HealthyWay
//
//  Created by Eugenity on 10.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWUserProfile.h"

@interface HWUserProfileData : NSObject<HWUserProfile>

- (void)setAvatarURLString:(NSString *)avatarURLString;

- (instancetype)initWithFirstName:(NSString *)firstName
                         lastName:(NSString *)lastName
                         nickName:(NSString *)nickName
                      dateOfBirth:(NSDate *)dateOfBirth
                           isMale:(NSNumber *)isMale;

@end
