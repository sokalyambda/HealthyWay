//
//  HWBaseAppManager.m
//  HealthyWay
//
//  Created by Eugenity on 28.06.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWBaseAppManager.h"

#import "HWUserProfileData+Mapping.h"

static NSString *const kFirstName   = @"firstName";
static NSString *const kLastName    = @"lastName";
static NSString *const kDateOfBirth = @"dateOfBirth";

@implementation HWBaseAppManager

#pragma mark - Accessors

- (BOOL)userExists
{
    return !!self.currentUser;
}

- (NSString *)currentUserId
{
    return self.currentUser.uid;
}

- (FIRUser *)currentUser
{
    return self.currentAuth.currentUser;
}

- (FIRAuth *)currentAuth
{
    return [FIRAuth authWithApp:[FIRApp defaultApp]];
}

- (FIRDatabaseReference *)dataBaseReference
{
    return [[FIRDatabase database] reference];
}

- (void)setUserProfileData:(HWUserProfileData *)userProfileData
{
    _userProfileData = userProfileData;
}

#pragma mark - Lifecycle

+ (instancetype)sharedManager
{
    static HWBaseAppManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

#pragma mark - Actions

#pragma marl - Authorization

- (void)signOutIfFirstLaunch
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults.dictionaryRepresentation.allKeys containsObject:IsFirstLaunch]) {
        if (self.currentUser) {
            NSError *error;
            [self.currentAuth signOut:&error];
            if (error) {
                DLog(@"Error: %@", error.localizedDescription);
            }
        }
        [defaults setBool:NO forKey:IsFirstLaunch];
    }
}

- (void)getTokenWithCompletion:(void(^)(NSString *token, NSError *error))completion
{
    if (self.currentUser) {
        [self.currentUser getTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
            if (completion) {
                completion(token, error);
            }
        }];
    } else {
        NSError *error = [NSError errorWithDomain:@"com.authorization.error" code:HWErrorCodeUserDoesntExist userInfo:@{
                                                                                                                        ErrorMessage: LOCALIZED(@"User doesn't exist.")
                                                                                                                        }];
        if (completion) {
            completion(nil, error);
        }
    }
}

- (void)sendPasswordResetWithEmail:(NSString *)email
                        completion:(void(^)(NSError *error))completion
{
    [self.currentAuth sendPasswordResetWithEmail:email completion:completion];
}

- (void)signInWithEmail:(NSString *)email
               password:(NSString *)password
             completion:(void(^)())completion
{
    [self.currentAuth signInWithEmail:email password:password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        if (completion) {
            completion(error);
        }
    }];
}

- (void)signUpWithEmail:(NSString *)email
               password:(NSString *)password
             completion:(void(^)(NSError *error))completion
{
    [self.currentAuth createUserWithEmail:email password:password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        if (completion) {
            completion(error);
        }
    }];
}

#pragma mark - Profile Changes

- (void)performProfileChangesRequestWithDisplayName:(NSString *)displayName
                                           photoURL:(NSURL *)photoURL
                                     withCompletion:(void(^)(NSError *error))completion
{
    FIRUserProfileChangeRequest *changeRequest = [self.currentUser profileChangeRequest];
    changeRequest.displayName = displayName;
    changeRequest.photoURL = photoURL;
    [changeRequest commitChangesWithCompletion:completion];
}

- (void)createUpdateUserProfileWithParameters:(NSDictionary *)userProfileParameters onCompletion:(void(^)(NSError *error))completion
{
    FIRDatabaseReference *userReference = [[self.dataBaseReference child:UsersKey] child:self.currentUserId];
    
    [userReference observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        if (snapshot.exists) {
            /**
             *  Update current user because we already have one created
             */
            [[[self.dataBaseReference child:UsersKey] child:self.currentUserId] updateChildValues:userProfileParameters];
        } else {
            /**
             *  Set the current user by his uid (it should be obtained after authorization)
             */
            [[[self.dataBaseReference child:UsersKey] child:self.currentUserId] setValue:userProfileParameters];
        }
        
        [self performProfileChangesRequestWithDisplayName:[NSString stringWithFormat:@"%@ %@", userProfileParameters[kFirstName], userProfileParameters[kLastName]] photoURL:nil withCompletion:completion];
    }];
}

#pragma mark - Users Fetch

- (void)fetchCurrentUserDataWithCompletion:(void(^)(NSArray *users, NSError *error))completion
{
    FIRDatabaseReference *usersReference = [self.dataBaseReference child:UsersKey];
    
    if (self.currentUser) {
        FIRDatabaseQuery *currentUserQuery = [[usersReference queryOrderedByKey] queryEqualToValue:self.currentUser.uid];
        WEAK_SELF;
        [currentUserQuery observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            
            NSDictionary *userData = [snapshot exists] ? snapshot.value[self.currentUser.uid] : nil;
            HWUserProfileData *currentUserProfile = [weakSelf mappedUserProfileDataFromDictionary:userData];
            [weakSelf setUserProfileData:currentUserProfile];
            
            if (currentUserProfile && completion) {
                completion(@[currentUserProfile], nil);
            } else if (completion) {
                NSError *error = [NSError errorWithDomain:@"com.user.mapping.error" code:HWErrorCodeMapping userInfo:@{
                                                                                                                       ErrorMessage: LOCALIZED(@"Error while mapping the current user")
                                                                                                                       }];
                completion(nil, error);
            }
        }];
    } else {
        NSError *error = [NSError errorWithDomain:@"com.fetchUsers.error" code:HWErrorCodeUserDoesntExist userInfo:@{ErrorMessage: @"User doesn't exist."}];
        if (completion) {
            completion(nil, error);
        }
    }
}

#pragma mark - Private

- (HWUserProfileData *)mappedUserProfileDataFromDictionary:(NSDictionary *)user
{
    EKObjectMapping *mapping = [HWUserProfileData defaultMapping];
    HWUserProfileData *mappedUser = [EKMapper objectFromExternalRepresentation:user withMapping:mapping];
    NSTimeInterval dateOfBirthTimeStamp = [user[kDateOfBirth] doubleValue];
    NSDate *dateOfBirth = [NSDate dateWithTimeIntervalSince1970:dateOfBirthTimeStamp];
    [mappedUser setValue:dateOfBirth forKey:@"dateOfBirth"];
    
    return mappedUser;
}

@end
