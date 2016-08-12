//
//  HWOperationsFacade.m
//  HealthyWay
//
//  Created by Eugenity on 12.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWOperationsFacade.h"

#import "HWOperationsManager.h"

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
    /**
     Create the auth operation
     
     - returns: Current authorization operation
     */
    HWAuthorizationOperation *operation = [[HWAuthorizationOperation alloc] initWithEmail:email
                                                                                 password:password
                                                                        confirmedPassword:confirmedPassword
                                                                                 authType:authType];
    [self.operationsManager enqueueOperation:operation onSuccess:^(HWBaseOperation *operation) {
        
        if (success) {
            success();
        }
        
    } onFailure:^(HWBaseOperation *operation, NSError *error, BOOL isCanceled) {
        if (failure) {
            failure(error, isCanceled);
        }
    }];
    return operation;
}

+ (HWBaseOperation *)fetchUsersWithFetchingType:(HWFetchUsersOperationType)fetchType
                                      onSuccess:(void(^)(NSArray *users))success
                                      onFailure:(FailureBlock)failure
{
    HWFetchUsersOperation *operation = [[HWFetchUsersOperation alloc] initWithFetchingType:fetchType];
    [self.operationsManager enqueueOperation:operation onSuccess:^(HWBaseOperation *operation) {
        
        if (success) {
            success(((HWFetchUsersOperation *)operation).users);
        }
        
    } onFailure:^(HWBaseOperation *operation, NSError *error, BOOL isCanceled) {
        if (failure) {
            failure(error, isCanceled);
        }
    }];
    return operation;
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
    HWCreateUpdateUserProfileOperation *operation = [[HWCreateUpdateUserProfileOperation alloc] initWithFirstName:firstName
                                                                                                         lastName:lastName
                                                                                                         nickName:nickName
                                                                                                      dateOfBirth:dateOfBirth
                                                                                                     avatarBase64:avatarBase64
                                                                                                           isMale:isMale];
    [self.operationsManager enqueueOperation:operation onSuccess:^(HWBaseOperation *operation) {
        if (success) {
            success();
        }
    } onFailure:^(HWBaseOperation *operation, NSError *error, BOOL isCanceled) {
        if (failure) {
            failure(error, isCanceled);
        }
    }];
    return operation;
}

+ (HWBaseOperation *)performAutologinOnSuccess:(void(^)(NSArray *users, NSString *token))success
                                     onFailure:(FailureBlock)failure
{
    HWAutologinOperation *autologinOperation = [[HWAutologinOperation alloc] init];
    HWFetchUsersOperation *fetchUsersOperation = [[HWFetchUsersOperation alloc] initWithFetchingType:HWFetchUsersOperationTypeCurrent];
    [fetchUsersOperation addDependency:autologinOperation];
    
    [self.operationsManager enqueueOperation:autologinOperation onSuccess:nil onFailure:^(HWBaseOperation *operation, NSError *error, BOOL isCanceled) {
        if (failure) {
            failure(error, isCanceled);
        }
    }];
    [self.operationsManager enqueueOperation:fetchUsersOperation onSuccess:^(HWBaseOperation *operation) {
        if (success) {
            success(fetchUsersOperation.users, autologinOperation.token);
        }
    } onFailure:^(HWBaseOperation *operation, NSError *error, BOOL isCanceled) {
        if (failure) {
            failure(error, isCanceled);
        }
    }];
    return autologinOperation;
}

@end
