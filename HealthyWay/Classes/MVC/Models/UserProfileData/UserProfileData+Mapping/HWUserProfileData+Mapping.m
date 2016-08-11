//
//  HWUserProfileData+Mapping.m
//  HealthyWay
//
//  Created by Eugenity on 10.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWUserProfileData+Mapping.h"

static NSString *const firstNameKey     = @"firstName";
static NSString *const lastNameKey      = @"lastName";
static NSString *const nickNameKey      = @"nickName";
static NSString *const avatarBase64Key  = @"avatarBase64";
static NSString *const isMaleKey        = @"isMale";

@implementation HWUserProfileData (Mapping)

+ (EKObjectMapping *)defaultMapping
{
    EKObjectMapping *mapping = [EKObjectMapping mappingForClass:[self class] withBlock:^(EKObjectMapping *mapping) {
        
        [mapping mapPropertiesFromArray:@[firstNameKey,
                                          lastNameKey,
                                          nickNameKey,
                                          avatarBase64Key,
                                          isMaleKey]];
        
        
    }];
    return mapping;
}

@end
