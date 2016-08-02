//
//  HWCredentials.h
//  HealthyWay
//
//  Created by Eugenity on 01.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

/**
 *  Class which is used for encapsulate logic of working with user credentials
 */
@interface HWCredentials : NSObject

@property (strong, nonatomic, readonly) NSString *email;
@property (strong, nonatomic, readonly) NSString *password;

+ (instancetype)credentialsWithEmail:(NSString *)email
                         andPassword:(NSString *)password;

@end
