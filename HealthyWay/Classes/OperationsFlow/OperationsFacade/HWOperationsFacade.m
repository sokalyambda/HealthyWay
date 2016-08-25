//
//  HWOperationsFacade.m
//  HealthyWay
//
//  Created by Eugenity on 12.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWOperationsFacade.h"

#import "HWOperationsManager.h"

#import "HWAuthorizationTasksFactory.h"
#import "HWUserProfilesTasksFactory.h"
#import "HWFriendsTasksFactory.h"

@implementation HWOperationsFacade

+ (HWOperationsManager *)operationsManager
{
    return [HWOperationsManager sharedManager];
}

+ (HWBaseOperation *)performAuthorizationProcessWithEmail:(NSString *)email
                                                 password:(NSString *)password
                                        confirmedPassword:(NSString *)confirmedPassword
                                                 authType:(HWAuthType)authType
                                                onSuccess:(void(^)())success
                                                onFailure:(FailureBlock)failure
{
    
    HWAuthorizationTasksFactory *factory = [[HWAuthorizationTasksFactory alloc] init];
    
    NSMutableDictionary *parameters = [@{} mutableCopy];
    if (email) {
        [parameters setObject:email forKey:TaskKeyEmail];
    }
    if (password) {
        [parameters setObject:password forKey:TaskKeyPassword];
    }
    if (confirmedPassword) {
        [parameters setObject:confirmedPassword forKey:TaskKeyConfirmedPassword];
    }
    [parameters setObject:@(authType) forKey:TaskKeyAuthType];
    
    id<HWTask> task = [factory taskWithType:HWTaskTypeAuthorization andParameters:parameters];
    
    return [self.operationsManager enqueueOperationForTask:task onSuccess:^(HWBaseOperation *operation) {
        
        if (success) {
            success();
        }
        
    } onFailure:^(HWBaseOperation *operation, NSError *error, BOOL isCanceled) {
        if (failure) {
            failure(error, isCanceled);
        }
    }];
}

+ (HWBaseOperation *)fetchUsersWithFetchingType:(HWFetchUsersTaskType)fetchType
                                   searchString:(NSString *)searchedText
                                      onSuccess:(void(^)(NSArray *users))success
                                      onFailure:(FailureBlock)failure
{
    HWUserProfilesTasksFactory *factory = [[HWUserProfilesTasksFactory alloc] init];
    
    NSMutableDictionary *parameters = [@{} mutableCopy];
    
    if (searchedText) {
        [parameters setObject:searchedText forKey:TaskKeyUsersSearchString];
    }
    [parameters setObject:@(fetchType) forKey:TaskKeyUsersFetchingType];
    id<HWTask> task = [factory taskWithType:HWTaskTypeFetchUsers andParameters:parameters];

    return [self.operationsManager enqueueOperationForTask:task onSuccess:^(HWBaseOperation *operation) {
        
        if (success) {
            success(task.outputFields[UsersKey]);
        }
        
    } onFailure:^(HWBaseOperation *operation, NSError *error, BOOL isCanceled) {
        if (failure) {
            failure(error, isCanceled);
        }
    }];
}

+ (HWBaseOperation *)createUpdateUserWithFirstName:(NSString *)firstName
                                          lastName:(NSString *)lastName
                                          nickName:(NSString *)nickName
                                       dateOfBirth:(NSDate *)dateOfBirth
                                        avatarData:(NSData *)avatarData
                                            isMale:(NSNumber *)isMale
                                         onSuccess:(void(^)())success
                                         onFailure:(FailureBlock)failure
{
    HWUserProfilesTasksFactory *factory = [[HWUserProfilesTasksFactory alloc] init];
    
    NSMutableDictionary *parameters = [@{} mutableCopy];
    
    if (firstName) {
        [parameters setObject:firstName forKey:TaskKeyFirstName];
    }
    if (lastName) {
        [parameters setObject:lastName forKey:TaskKeyLastName];
    }
    if (nickName) {
        [parameters setObject:nickName forKey:TaskKeyNickName];
    }
    if (dateOfBirth) {
        [parameters setObject:dateOfBirth forKey:TaskKeyDateOfBirthName];
    }
    if (avatarData) {
        [parameters setObject:avatarData forKey:TaskKeyAvatarData];
    }
    [parameters setObject:isMale forKey:TaskKeyIsMale];
    
    id <HWTask> task = [factory taskWithType:HWTaskTypeCreateUpdateUserProfile andParameters:parameters];

    return [self.operationsManager enqueueOperationForTask:task onSuccess:^(HWBaseOperation *operation) {
        if (success) {
            success();
        }
    } onFailure:^(HWBaseOperation *operation, NSError *error, BOOL isCanceled) {
        if (failure) {
            failure(error, isCanceled);
        }
    }];
}

+ (HWBaseOperation *)performAutologinOnSuccess:(void(^)(NSArray *users, NSString *token))success
                                     onFailure:(FailureBlock)failure
{
    HWAuthorizationTasksFactory *authFactory = [[HWAuthorizationTasksFactory alloc] init];
    HWUserProfilesTasksFactory *usersFactory = [[HWUserProfilesTasksFactory alloc] init];
    
    id<HWTask> autologinTask = [authFactory taskWithType:HWTaskTypeAutologin andParameters:nil];
    id<HWTask> fetchUsersTask = [usersFactory taskWithType:HWTaskTypeFetchUsers andParameters:@{
                                                                                                TaskKeyUsersFetchingType: @(HWFetchUsersTaskTypeCurrent)                                              }];
    
    HWBaseOperation *autologinOperation = [self.operationsManager enqueueOperationForTask:autologinTask onSuccess:nil onFailure:^(HWBaseOperation *operation, NSError *error, BOOL isCanceled) {
        if (failure) {
            failure(error, isCanceled);
        }
    }];
    HWBaseOperation *fetchUsersOperation = [self.operationsManager enqueueOperationForTask:fetchUsersTask onSuccess:^(HWBaseOperation *operation) {
        if (success) {
            success(fetchUsersTask.outputFields[UsersKey], autologinTask.outputFields[TaskKeyToken]);
        }
    } onFailure:^(HWBaseOperation *operation, NSError *error, BOOL isCanceled) {
        if (failure) {
            failure(error, isCanceled);
        }
    }];
    
    [fetchUsersOperation addDependency:autologinOperation];
    
    return autologinOperation;
}

+ (HWBaseOperation *)sendFriendsRequestToUserWithId:(NSString *)userId
                                          onSuccess:(void(^)())success
                                          onFailure:(TaskFailure)failure
{
    HWFriendsTasksFactory *factory = [[HWFriendsTasksFactory alloc] init];
    
    NSMutableDictionary *parameters = [@{} mutableCopy];
    
    if (userId) {
        [parameters setObject:userId forKey:TaskKeyRemoteUserId];
    }
    [parameters setObject:@(HWSendOrDenyFriendsRequestTaskTypeSend) forKey:TaskKeyFriendRequestType];
    
    id <HWTask> task = [factory taskWithType:HWTaskTypeSendOrDenyFriendsRequest andParameters:parameters];
    
    HWBaseOperation *operation = [self.operationsManager enqueueOperationForTask:task onSuccess:^(HWBaseOperation *operation) {
        if (success) {
            success();
        }
    } onFailure:^(HWBaseOperation *operation, NSError *error, BOOL isCanceled) {
        if (failure) {
            failure(error);
        }
    }];
    return operation;
}

+ (HWBaseOperation *)denyFriendsRequestToUserWithId:(NSString *)userId
                                          onSuccess:(void(^)())success
                                          onFailure:(TaskFailure)failure
{
    HWFriendsTasksFactory *factory = [[HWFriendsTasksFactory alloc] init];
    
    NSMutableDictionary *parameters = [@{} mutableCopy];
    
    if (userId) {
        [parameters setObject:userId forKey:TaskKeyRemoteUserId];
    }
    [parameters setObject:@(HWSendOrDenyFriendsRequestTaskTypeDeny) forKey:TaskKeyFriendRequestType];
    id<HWTask> task = [factory taskWithType:HWTaskTypeSendOrDenyFriendsRequest andParameters:parameters];
    
    HWBaseOperation *operation = [self.operationsManager enqueueOperationForTask:task onSuccess:^(HWBaseOperation *operation) {
        if (success) {
            success();
        }
    } onFailure:^(HWBaseOperation *operation, NSError *error, BOOL isCanceled) {
        if (failure) {
            failure(error);
        }
    }];
    return operation;
}

+ (HWBaseOperation *)fetchRequestedFriendsIdsOnSuccess:(void(^)(NSArray *requestedFriendsIds))success
                                             onFailure:(TaskFailure)failure
{
    HWFriendsTasksFactory *facrory = [[HWFriendsTasksFactory alloc] init];
    id<HWTask> task = [facrory taskWithType:HWTaskTypeFetchRequestedFriends andParameters:@{
                                                                                            TaskKeyFriendRequestType: @(HWFetchRequestedFriendsTaskTypeIds)
                                                                                            }];
    HWBaseOperation *operation = [self.operationsManager enqueueOperationForTask:task onSuccess:^(HWBaseOperation *operation) {
        if (success) {
            success(task.outputFields[TaskKeyRequestedFriendsIds]);
        }
    } onFailure:^(HWBaseOperation *operation, NSError *error, BOOL isCanceled) {
        if (failure) {
            failure(error);
        }
    }];
    return operation;
}

+ (HWBaseOperation *)fetchRequestedFriendsOnSuccess:(void(^)(NSArray *requestedFriends))success
                                          onFailure:(TaskFailure)failure
{
    HWFriendsTasksFactory *factory = [[HWFriendsTasksFactory alloc] init];
    id<HWTask> task = [factory taskWithType:HWTaskTypeFetchRequestedFriends andParameters:@{
                                                                                            TaskKeyFetchRequestedFriendsType: @(HWFetchRequestedFriendsTaskTypeEntities)
                                                                                            }];
    
    HWBaseOperation *operation = [self.operationsManager enqueueOperationForTask:task onSuccess:^(HWBaseOperation *operation) {
        if (success) {
            success(task.outputFields[TaskKeyRequestedFriends]);
        }
    } onFailure:^(HWBaseOperation *operation, NSError *error, BOOL isCanceled) {
        if (failure) {
            failure(error);
        }
    }];
    return operation;
}

+ (HWBaseOperation *)fetchRequestingFriendsOnSuccess:(void(^)(NSArray *requestingFriends))success
                                           onFailure:(TaskFailure)failure
{
    HWFriendsTasksFactory *factory = [[HWFriendsTasksFactory alloc] init];
    id<HWTask> task = [factory taskWithType:HWTaskTypeFetchRequestingFriends andParameters:nil];
    
    HWBaseOperation *operation = [self.operationsManager enqueueOperationForTask:task onSuccess:^(HWBaseOperation *operation) {
        if (success) {
            success(task.outputFields[TaskKeyRequestingFriends]);
        }
    } onFailure:^(HWBaseOperation *operation, NSError *error, BOOL isCanceled) {
        if (failure) {
            failure(error);
        }
    }];
    return operation;
}

@end
