//
//  HWOperationsFacade.m
//  HealthyWay
//
//  Created by Eugenity on 12.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWOperationsFacade.h"

#import "HWOperationsManager.h"

#import "HWBaseOperation.h"

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

    HWAuthorizationTask *task = [[HWAuthorizationTask alloc] initWithEmail:email
                                                                  password:password
                                                         confirmedPassword:confirmedPassword
                                                                  authType:authType];
    
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
    HWFetchUsersTask *task = [[HWFetchUsersTask alloc] initWithUsersFetchingType:fetchType
                                                                    searchString:searchedText];
    return [self.operationsManager enqueueOperationForTask:task onSuccess:^(HWBaseOperation *operation) {
        
        if (success) {
            success(task.users);
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
                                      avatarBase64:(NSString *)avatarBase64
                                            isMale:(NSNumber *)isMale
                                         onSuccess:(void(^)())success
                                         onFailure:(FailureBlock)failure
{
    HWCreateUpdateUserProfileTask *task = [[HWCreateUpdateUserProfileTask alloc] initWithFirstName:firstName
                                                                                          lastName:lastName
                                                                                          nickName:nickName
                                                                                       dateOfBirth:dateOfBirth
                                                                                      avatarBase64:avatarBase64
                                                                                            isMale:isMale];

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
    HWAutologinTask *autologinTask = [[HWAutologinTask alloc] init];
    HWFetchUsersTask *fetchUsersTask = [[HWFetchUsersTask alloc] initWithUsersFetchingType:HWFetchUsersTaskTypeCurrent];
    
    HWBaseOperation *autologinOperation = [self.operationsManager enqueueOperationForTask:autologinTask onSuccess:nil onFailure:^(HWBaseOperation *operation, NSError *error, BOOL isCanceled) {
        if (failure) {
            failure(error, isCanceled);
        }
    }];
    HWBaseOperation *fetchUsersOperation = [self.operationsManager enqueueOperationForTask:fetchUsersTask onSuccess:^(HWBaseOperation *operation) {
        if (success) {
            success(fetchUsersTask.users, autologinTask.token);
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
    HWSendOrDenyFriendsRequestTask *task = [[HWSendOrDenyFriendsRequestTask alloc] initWithRemoteUserId:userId andType:HWSendOrDenyFriendsRequestTaskTypeSend];
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
    HWSendOrDenyFriendsRequestTask *task = [[HWSendOrDenyFriendsRequestTask alloc] initWithRemoteUserId:userId andType:HWSendOrDenyFriendsRequestTaskTypeDeny];
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
    HWFetchRequestedFriendsTask *task = [[HWFetchRequestedFriendsTask alloc] initWithFetchType:HWFetchRequestedFriendsTaskTypeIds];
    HWBaseOperation *operation = [self.operationsManager enqueueOperationForTask:task onSuccess:^(HWBaseOperation *operation) {
        if (success) {
            success(task.requestedFriendsIds);
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
    HWFetchRequestedFriendsTask *task = [[HWFetchRequestedFriendsTask alloc] initWithFetchType:HWFetchRequestedFriendsTaskTypeEntities];
    HWBaseOperation *operation = [self.operationsManager enqueueOperationForTask:task onSuccess:^(HWBaseOperation *operation) {
        if (success) {
            success(task.requestedFriends);
        }
    } onFailure:^(HWBaseOperation *operation, NSError *error, BOOL isCanceled) {
        if (failure) {
            failure(error);
        }
    }];
    return operation;
}

@end
