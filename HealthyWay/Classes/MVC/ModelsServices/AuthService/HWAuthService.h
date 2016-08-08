//
//  HWAuthService.h
//  HealthyWay
//
//  Created by Eugenity on 29.06.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

@class HWSignInOperation;

@interface HWAuthService : NSObject

+ (HWSignInOperation *)signInOperationForEmail:(NSString *)email
                                      password:(NSString *)password;

@end
