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

static NSString *const kFirstName           = @"firstName";
static NSString *const kLastName            = @"lastName";
static NSString *const kNickName            = @"nickName";
static NSString *const kIsMale              = @"isMale";
static NSString *const kDateOfBirth         = @"dateOfBirth";

@interface HWCreateUpdateUserProfileTask ()

@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *nickName;
@property (nonatomic) NSDate *dateOfBirth;
@property (nonatomic) NSNumber *isMale;
@property (nonatomic) NSData *avatarData;

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

#pragma mark - Lifecycle

- (instancetype)initWithFirstName:(NSString *)firstName
                         lastName:(NSString *)lastName
                         nickName:(NSString *)nickName
                      dateOfBirth:(NSDate *)dateOfBirth
                       avatarData:(NSData *)avatarData
                           isMale:(NSNumber *)isMale
{
    self = [super init];
    if (self) {
        _userProfileData = [[HWUserProfileData alloc] initWithFirstName:firstName
                                                               lastName:lastName
                                                               nickName:nickName
                                                            dateOfBirth:dateOfBirth
                                                                 isMale:isMale];
        _avatarData = avatarData;
    }
    return self;
}

#pragma mark - Actions

- (void)performCurrentTaskOnSuccess:(TaskSuccess)success
                          onFailure:(TaskFailure)failure
{
    [super performCurrentTaskOnSuccess:success onFailure:failure];
    WEAK_SELF;
    [HWValidator validateFirstName:self.firstName lastName:self.lastName nickName:self.nickName dateOfBirth:self.dateOfBirth onSuccess:^{
        NSDictionary *parameters = @{
                                     kFirstName: weakSelf.firstName,
                                     kLastName: weakSelf.lastName,
                                     kNickName: weakSelf.nickName,
                                     kIsMale: weakSelf.isMale,
                                     kDateOfBirth: @([weakSelf.dateOfBirth timeIntervalSince1970]),
                                     };
        [HWUserProfileService createUpdateUserProfileWithParameters:parameters andAvatarData:weakSelf.avatarData onCompletion:^(NSError *error) {
            
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
