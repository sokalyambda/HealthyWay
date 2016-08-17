//
//  HWCreateUpdateUserProfileTask.m
//  HealthyWay
//
//  Created by Eugenity on 15.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWCreateUpdateUserProfileTask.h"

#import "HWUserProfileData.h"

#import "HWUserProfileService.h"

NSString *const kFirstName           = @"firstName";
NSString *const kLastName            = @"lastName";
NSString *const kNickName            = @"nickName";
NSString *const kIsMale              = @"isMale";
NSString *const kDateOfBirth         = @"dateOfBirth";
NSString *const kAvatarBase64String  = @"avatarBase64";

@interface HWCreateUpdateUserProfileTask ()

@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *nickName;
@property (nonatomic) NSDate *dateOfBirth;
@property (nonatomic) NSString *avatarBase64String;
@property (nonatomic) NSNumber *isMale;

@property (strong, nonatomic) NSError *error;

@end

@implementation HWCreateUpdateUserProfileTask

@synthesize error = _error;

#pragma mark - Accessors

- (NSString *)firstName
{
    return self.userProfileData.firstName;
}

- (NSString *)lastName
{
    return self.userProfileData.lastName;
}

- (NSString *)nickName
{
    return self.userProfileData.nickName;
}

- (NSDate *)dateOfBirth
{
    return self.userProfileData.dateOfBirth;
}

- (NSNumber *)isMale
{
    return self.userProfileData.isMale;
}

- (NSString *)avatarBase64String
{
    return self.userProfileData.avatarBase64;
}

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

#pragma mark - Actions

- (void)performCurrentTaskOnSuccess:(TaskSuccess)success
                          onFailure:(TaskFailure)failure
{
    WEAK_SELF;
    [HWValidator validateFirstName:self.firstName lastName:self.lastName nickName:self.nickName dateOfBirth:self.dateOfBirth onSuccess:^{
        NSDictionary *parameters = @{
                                     kFirstName: weakSelf.firstName,
                                     kLastName: weakSelf.lastName,
                                     kNickName: weakSelf.nickName,
                                     kIsMale: weakSelf.isMale,
                                     kDateOfBirth: @([weakSelf.dateOfBirth timeIntervalSince1970]),
                                     kAvatarBase64String: weakSelf.avatarBase64String
                                     };
        [HWUserProfileService createUpdateUserProfileWithParameters:parameters onCompletion:^(NSError *error) {
            
            weakSelf.error = error;
            
            if (error && failure) {
                return failure(error);
            }
            if (!error && success) {
                return success();
            }
            
        }];
    } onFailure:^(NSMutableArray *errorArray) {
        
        NSError *validationError = [NSError errorWithDomain:@"com.validation.error" code:HWErrorCodeValidation userInfo:@{ErrorsArrayKey: errorArray}];
        weakSelf.error = validationError;
        [HWValidator cleanValidationErrorArray];
        
        if (failure) {
            failure(validationError);
        }
    }];
}

@end
