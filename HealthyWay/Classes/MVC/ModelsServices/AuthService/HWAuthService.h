//
//  HWAuthService.h
//  HealthyWay
//
//  Created by Eugenity on 29.06.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

typedef void(^HWAuthorizationCompletion)(NSError *error);

@class HWAuthorizationOperation;
@class HWCredentials;

@interface HWAuthService : NSObject

- (HWAuthorizationOperation *)authorizationOperationForCredentials:(HWCredentials *)credentials
                                                    withCompletion:(HWAuthorizationCompletion)completion;

@end
