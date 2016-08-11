//
//  HWCreateUpdateUserProfileOperation.m
//  HealthyWay
//
//  Created by Eugenity on 10.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWCreateUpdateUserProfileOperation.h"

#import "HWUserProfileData.h"

static NSString *const kFirstName           = @"firstName";
static NSString *const kLastName            = @"lastName";
static NSString *const kNickName            = @"nickName";
static NSString *const kIsMale              = @"isMale";
static NSString *const kDateOfBirth         = @"dateOfBirth";
static NSString *const kAvatarBase64String  = @"avatarBase64";

@interface HWCreateUpdateUserProfileOperation ()

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *nickName;
@property (strong, nonatomic) NSDate *dateOfBirth;
@property (strong, nonatomic) NSString *avatarBase64String;
@property (assign, nonatomic) NSNumber * isMale;

@property (strong, nonatomic, readwrite) NSError *error;

@end

@implementation HWCreateUpdateUserProfileOperation

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

- (instancetype)initWithUserProfileData:(HWUserProfileData *)userProfileData
{
    self = [super init];
    if (self) {
        _userProfileData = userProfileData;
        /**
         *  The operation is ready when all parameters have been set
         */
        [self makeReady];
    }
    return self;
}

#pragma mark - Actioms

- (void)start
{
    if (![NSThread isMainThread]) {
        return [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
    }
    
    if (self.isCancelled) {
        return [self finish:YES];
    }
    
    /**
     *  The operation begins executing now
     */
    [self execute];
    
    [self createUpdateUserProfile];
}

- (void)createUpdateUserProfile
{
    if (self.isCancelled) {
        return;
    }
    
    FIRUser *user = [HWBaseAppManager sharedManager].currentUser;
    FIRDatabaseReference *userReference = [[[HWBaseAppManager sharedManager].dataBaseReference child:UsersKey] child:user.uid];
    
    [userReference observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
    
        if (self.isCancelled) {
            return;
        }
        
        NSDictionary *parameters = @{
                                     kFirstName: self.firstName,
                                     kLastName: self.lastName,
                                     kNickName: self.nickName,
                                     kIsMale: self.isMale,
                                     kDateOfBirth: @([self.dateOfBirth timeIntervalSince1970]),
                                     kAvatarBase64String: self.avatarBase64String
                                     };
        
        FIRUserProfileChangeRequest *changeRequest = [user profileChangeRequest];
        changeRequest.displayName = [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
        
        if (snapshot.exists) {
            /**
             *  Update current user because we already have one created
             */
            [[[[HWBaseAppManager sharedManager].dataBaseReference child:UsersKey] child:user.uid] updateChildValues:parameters];
        } else {
            /**
             *  Set the current user by his uid (it should be obtained after authorization)
             */
            [[[[HWBaseAppManager sharedManager].dataBaseReference child:UsersKey] child:user.uid] setValue:parameters];
        }
        
        if (self.isCancelled) {
            return;
        }
        
        WEAK_SELF;
        [changeRequest commitChangesWithCompletion:^(NSError *_Nullable error) {
            weakSelf.error = error;
            
            [weakSelf completeTheExecution];
        }];
        
    }];
    
}

@end
