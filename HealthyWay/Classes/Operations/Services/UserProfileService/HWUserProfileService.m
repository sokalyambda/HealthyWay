//
//  HWUserProfileService.m
//  HealthyWay
//
//  Created by Eugenity on 10.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWUserProfileService.h"

#import "HWUserProfileData.h"

#import "HWCreateUpdateUserProfileOperation.h"

@interface HWUserProfileService ()

@property (strong, nonatomic) NSOperationQueue *userCreateUpdateOperations;

@property (strong, nonatomic) HWUserProfileData *userProfileData;

@end

@implementation HWUserProfileService

#pragma mark - Lifecycle

- (instancetype)initWithFirstName:(NSString *)firstName
                         lastName:(NSString *)lastName
                         nickName:(NSString *)nickName
                      dateOfBirth:(NSDate *)dateOfBirth
                     avatarBase64:(NSString *)avatarBase64
                           isMale:(NSNumber *)isMale
{
    self = [super init];
    if (self) {
        _userProfileData = [[HWUserProfileData alloc] initWithFirstName:firstName
                                                               lastName:lastName
                                                               nickName:nickName
                                                            dateOfBirth:dateOfBirth
                                                           avatarBase64:avatarBase64
                                                                 isMale:isMale];
    }
    return self;
}

#pragma mark - Accessors

- (NSOperationQueue *)userCreateUpdateOperations
{
    if (!_userCreateUpdateOperations) {
        _userCreateUpdateOperations = [[NSOperationQueue alloc] init];
        _userCreateUpdateOperations.name = @"com_create_update_operations_queue";
        _userCreateUpdateOperations.maxConcurrentOperationCount = 1;
    }
    return _userCreateUpdateOperations;
}

- (HWCreateUpdateUserProfileOperation *)createUpdateUserWithCompletion:(HWUserCreateUpdateCompletion)completion
{
    HWCreateUpdateUserProfileOperation *operation = [[HWCreateUpdateUserProfileOperation alloc] initWithUserProfileData:self.userProfileData];
    [self.userCreateUpdateOperations addOperation:operation];
    
    __block HWCreateUpdateUserProfileOperation *weakOperation = operation;
    
    [operation setCompletionBlock:^{
        
        NSError *error = weakOperation.error;
        /**
         *  We have to guarantee that UI things will be performed on the main thread;
         */
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (completion) {
                completion(error);
            }
        });
    }];
    return operation;
}

@end
