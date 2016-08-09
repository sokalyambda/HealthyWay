//
//  HWAuthService.h
//  HealthyWay
//
//  Created by Eugenity on 29.06.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWAuthTypes.h"

typedef void(^HWAuthorizationCompletion)(NSError *error);

@class HWAuthorizationOperation;

@interface HWAuthService : NSObject

- (instancetype)initWithEmail:(NSString *)email
                     password:(NSString *)password
            confirmedPassword:(NSString *)confirmedPassword
                     authType:(HWAuthType)authType;

- (HWAuthorizationOperation *)authorizationOperationWithCompletion:(HWAuthorizationCompletion)completion;

@end
