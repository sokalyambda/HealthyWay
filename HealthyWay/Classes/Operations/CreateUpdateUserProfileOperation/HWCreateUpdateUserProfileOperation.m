//
//  HWCreateUpdateUserProfileOperation.m
//  HealthyWay
//
//  Created by Eugenity on 10.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

typedef NS_ENUM(NSUInteger, HWCreateUpdateUserProfileOperationErrorType) {
    HWCreateUpdateUserProfileOperationErrorTypeValidation = -999
};

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
                                                                 isMale:isMale];;
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
    
    WEAK_SELF;
    [HWValidator validateFirstName:self.firstName lastName:self.lastName nickName:self.nickName dateOfBirth:self.dateOfBirth onSuccess:^{
        FIRUser *user = [HWBaseAppManager sharedManager].currentUser;
        FIRDatabaseReference *userReference = [[[HWBaseAppManager sharedManager].dataBaseReference child:UsersKey] child:user.uid];
        
        [userReference observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            
            if (weakSelf.isCancelled) {
                return [weakSelf finish:YES];
            }
            
            NSDictionary *parameters = @{
                                         kFirstName: weakSelf.firstName,
                                         kLastName: weakSelf.lastName,
                                         kNickName: weakSelf.nickName,
                                         kIsMale: weakSelf.isMale,
                                         kDateOfBirth: @([weakSelf.dateOfBirth timeIntervalSince1970]),
                                         kAvatarBase64String: weakSelf.avatarBase64String
                                         };
            
            FIRUserProfileChangeRequest *changeRequest = [user profileChangeRequest];
            changeRequest.displayName = [NSString stringWithFormat:@"%@ %@", weakSelf.firstName, weakSelf.lastName];
            
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
            
            if (weakSelf.isCancelled) {
                return [weakSelf finish:YES];
            }
            
            [changeRequest commitChangesWithCompletion:^(NSError *_Nullable error) {
                weakSelf.error = error;
                
                [weakSelf completeTheExecution];
            }];
            
        }];
    } onFailure:^(NSMutableArray *errorArray) {
        if (weakSelf.isCancelled) {
            return [weakSelf finish:YES];
        }
        
        NSError *validationError = [NSError errorWithDomain:@"com.eugenity" code:HWCreateUpdateUserProfileOperationErrorTypeValidation userInfo:@{ErrorsArrayKey: errorArray}];
        weakSelf.error = validationError;
        [HWValidator cleanValidationErrorArray];
        
        [weakSelf completeTheExecution];
    }];
    
    
    
}

@end
