//
//  HWUserProfileData.m
//  HealthyWay
//
//  Created by Eugenity on 10.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWUserProfileData.h"

@implementation HWUserProfileData

@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize nickName = _nickName;
@synthesize dateOfBirth = _dateOfBirth;
@synthesize avatarBase64 = _avatarBase64;
@synthesize isMale = _isMale;
@synthesize userId = _userId;

#pragma mark - Accessors

- (NSString *)fullName
{
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

#pragma mark - Lifecycle

- (instancetype)initWithFirstName:(NSString *)firstName
                         lastName:(NSString *)lastName
                         nickName:(NSString *)nickName
                      dateOfBirth:(NSDate *)dateOfBirth
                     avatarBase64:(NSString *)avatarBase64
                           isMale:(NSNumber *)isMale
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
