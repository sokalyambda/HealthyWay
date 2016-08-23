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
@synthesize isMale = _isMale;
@synthesize userId = _userId;
@synthesize avatarURLString = _avatarURLString;

#pragma mark - Accessors

- (NSString *)fullName
{
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

- (void)setAvatarURLString:(NSString *)avatarURLString
{
    _avatarURLString = avatarURLString;
}

#pragma mark - Lifecycle

- (instancetype)initWithFirstName:(NSString *)firstName
                         lastName:(NSString *)lastName
                         nickName:(NSString *)nickName
                      dateOfBirth:(NSDate *)dateOfBirth
                           isMale:(NSNumber *)isMale
{
    self = [super init];
    if (self) {
        _firstName = firstName;
        _lastName = lastName;
        _nickName = nickName;
        _dateOfBirth = dateOfBirth;
        _isMale = isMale;
    }
    return self;
}

@end
