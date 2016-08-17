//
//  HWAuthorizationTask.h
//  HealthyWay
//
//  Created by Eugenity on 15.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

@class HWCredentials;

#import "HWBaseTask.h"

@interface HWAuthorizationTask : HWBaseTask

@property (strong, nonatomic, readonly) HWCredentials *credentials;

- (instancetype)initWithEmail:(NSString *)email
                     password:(NSString *)password
            confirmedPassword:(NSString *)confirmedPassword
                     authType:(HWAuthType)authType;

@end
