//
//  HWOperationsFacade.h
//  HealthyWay
//
//  Created by Eugenity on 12.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWAuthTypes.h"

#import "HWTasks.h"

@class HWBaseOperation;

typedef void(^FailureBlock)(NSError *error, BOOL isCancelled);

@interface HWOperationsFacade : NSObject

+ (HWBaseOperation *)performAuthorizationProcessWithEmail:(NSString *)email
                                                 password:(NSString *)password
                                        confirmedPassword:(NSString *)confirmedPassword
                                                 authType:(HWAuthType)authType
                                                onSuccess:(void(^)())success
                                                onFailure:(FailureBlock)failure;

+ (HWBaseOperation *)fetchUsersWithFetchingType:(HWFetchUsersTaskType)fetchType
                                      onSuccess:(void(^)(NSArray *users))success
                                      onFailure:(FailureBlock)failure;

+ (HWBaseOperation *)createUpdateUserWithFirstName:(NSString *)firstName
                                          lastName:(NSString *)lastName
                                          nickName:(NSString *)nickName
                                       dateOfBirth:(NSDate *)dateOfBirth
                                      avatarBase64:(NSString *)avatarBase64
                                            isMale:(NSNumber *)isMale
                                         onSuccess:(void(^)())success
                                         onFailure:(FailureBlock)failure;

+ (HWBaseOperation *)performAutologinOnSuccess:(void(^)(NSArray *users, NSString *token))success
                                     onFailure:(FailureBlock)failure;

@end
