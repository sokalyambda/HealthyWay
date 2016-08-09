//
//  HWCredentials.h
//  HealthyWay
//
//  Created by Eugenity on 01.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWAuthTypes.h"

/**
 *  Class which is used for encapsulate logic of working with user credentials
 */
@interface HWCredentials : NSObject

@property (strong, nonatomic, readonly) NSString *email;
@property (strong, nonatomic, readonly) NSString *password;
@property (strong, nonatomic, readonly) NSString *confirmedPassword;
@property (assign, nonatomic, readonly) HWAuthType authType;

+ (instancetype)credentialsWithEmail:(NSString *)email
                            password:(NSString *)password
                   confirmedPassword:(NSString *)confirmedPassword
                            authType:(HWAuthType)authType;

@end
