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

+ (instancetype)credentialsWithEmail:(NSString *)email andPassword:(NSString *)password
{
    return [[self alloc] initWithEmail:email andPassword:password];
}

- (instancetype)initWithEmail:(NSString *)email andPassword:(NSString *)password
{
    self = [super init];
    if (self) {
        _email = email;
        _password = password;
    }
    return self;
}

@end
