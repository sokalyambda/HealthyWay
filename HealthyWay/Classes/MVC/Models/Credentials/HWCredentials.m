//
//  HWCredentials.m
//  HealthyWay
//
//  Created by Eugenity on 01.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWCredentials.h"

@implementation HWCredentials

#pragma mark - Lifecycle

+ (instancetype)credentialsWithEmail:(NSString *)email
                            password:(NSString *)password
                   confirmedPassword:(NSString *)confirmedPassword
                            authType:(HWAuthType)authType
{
    return [[self alloc] initWithEmail:email password:password confirmedPassword:confirmedPassword authType:authType];
}

- (instancetype)initWithEmail:(NSString *)email
                     password:(NSString *)password
            confirmedPassword:(NSString *)confirmedPassword
                     authType:(HWAuthType)authType
{
    self = [super init];
    if (self) {
        _email = email;
        _password = password;
        _confirmedPassword = confirmedPassword;
        _authType = authType;
    }
    return self;
}

@end
