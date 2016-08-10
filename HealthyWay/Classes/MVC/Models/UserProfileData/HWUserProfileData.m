//
//  HWUserProfileData.m
//  HealthyWay
//
//  Created by Eugenity on 10.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWUserProfileData.h"

@implementation HWUserProfileData

#pragma mark - Lifecycle

- (instancetype)initWithFirstName:(NSString *)firstName
                         lastName:(NSString *)lastName
                         nickName:(NSString *)nickName
                      dateOfBirth:(NSDate *)dateOfBirth
                     avatarBase64:(NSString *)avatarBase64
                           isMale:(BOOL)isMale
{
    self = [super init];
    if (self) {
        _firstName = firstName;
        _lastName = lastName;
        _nickName = nickName;
        _dateOfBirth = dateOfBirth;
        _isMale = isMale;
        _avatarBase64 = avatarBase64;
    }
    return self;
}

@end
