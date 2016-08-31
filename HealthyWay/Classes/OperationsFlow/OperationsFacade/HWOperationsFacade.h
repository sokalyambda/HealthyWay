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
                                   searchString:(NSString *)searchedText
                                      onSuccess:(void(^)(NSArray *users))success
                                      onFailure:(FailureBlock)failure;

+ (HWBaseOperation *)createUpdateUserWithFirstName:(NSString *)firstName
                                          lastName:(NSString *)lastName
                                          nickName:(NSString *)nickName
                                       dateOfBirth:(NSDate *)dateOfBirth
                                        avatarData:(NSData *)avatarData
                                            isMale:(NSNumber *)isMale
                                         onSuccess:(void(^)())success
                                         onFailure:(FailureBlock)failure;

+ (HWBaseOperation *)performAutologinOnSuccess:(void(^)(NSArray *users, NSString *token))success
                                     onFailure:(FailureBlock)failure;

+ (HWBaseOperation *)sendFriendsRequestToUserWithId:(NSString *)userId
                                          onSuccess:(void(^)())success
                                          onFailure:(TaskFailure)failure;

+ (HWBaseOperation *)denyFriendsRequestToUserWithId:(NSString *)userId
                                          onSuccess:(void(^)())success
                                          onFailure:(TaskFailure)failure;

+ (HWBaseOperation *)fetchRequestedFriendsIdsOnSuccess:(void(^)(NSArray *requestedFriendsIds))success
                                             onFailure:(TaskFailure)failure;

+ (HWBaseOperation *)fetchRequestedFriendsOnSuccess:(void(^)(NSArray *requestedFriends))success
                                          onFailure:(TaskFailure)failure;

+ (HWBaseOperation *)fetchRequestingFriendsOnSuccess:(void(^)(NSArray *requestingFriends))success
                                           onFailure:(TaskFailure)failure;

+ (HWBaseOperation *)addUserToFriendsWithId:(NSString *)userId
                                  onSuccess:(void(^)())success
                                  onFailure:(TaskFailure)failure;

@end
