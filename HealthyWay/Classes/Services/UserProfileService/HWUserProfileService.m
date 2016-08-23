//
//  HWUserProfileService.m
//  HealthyWay
//
//  Created by Eugenity on 12.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWUserProfileService.h"

#import "HWUserProfileData+Mapping.h"

static NSString *const kFirstName           = @"firstName";
static NSString *const kLastName            = @"lastName";
static NSString *const kDateOfBirth         = @"dateOfBirth";
static NSString *const kUserId              = @"userId";
static NSString *const kRequestedFriendsIds = @"requestedFriendsIds";

@implementation HWUserProfileService

#pragma mark - Accessors

+ (NSString *)currentUserId
{
    return self.currentUser.uid;
}

+ (FIRAuth *)currentAuth
{
    return [FIRAuth authWithApp:[FIRApp defaultApp]];
}

+ (FIRUser *)currentUser
{
    return self.currentAuth.currentUser;
}

+ (FIRDatabaseReference *)dataBaseReference
{
    return [[FIRDatabase database] reference];
}

#pragma mark - Actions

+ (void)performProfileChangesRequestWithDisplayName:(NSString *)displayName
                                           photoURL:(NSURL *)photoURL
                                     withCompletion:(void(^)(NSError *error))completion
{
    FIRUserProfileChangeRequest *changeRequest = self.currentUser.profileChangeRequest;
    changeRequest.displayName = displayName;
    changeRequest.photoURL = photoURL;
    [changeRequest commitChangesWithCompletion:completion];
}

+ (void)fetchCurrentUserDataWithCompletion:(void(^)(NSArray *users, NSError *error))completion
{
    FIRDatabaseReference *usersReference = [self.dataBaseReference child:UsersKey];
    
    if (self.currentUser) {
        FIRDatabaseQuery *currentUserQuery = [[usersReference queryOrderedByKey] queryEqualToValue:self.currentUserId];

        [currentUserQuery observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            
            NSDictionary *userData = [snapshot exists] ? snapshot.value[self.currentUserId] : nil;
            HWUserProfileData *currentUserProfile = [self mappedUserProfileDataFromDictionary:userData];
            [[HWBaseAppManager sharedManager] setUserProfileData:currentUserProfile];
            
            if (currentUserProfile && completion) {
                completion(@[currentUserProfile], nil);
            } else if (completion) {
                completion(@[], nil);
            }
        }];
    } else {
        NSError *error = [NSError errorWithDomain:@"com.fetchUsers.error" code:HWErrorCodeUserDoesntExist userInfo:@{ErrorMessage: @"User doesn't exist."}];
        if (completion) {
            completion(nil, error);
        }
    }
}

+ (void)fetchUsersDataWithSearchString:(NSString *)searchString
                          onCompletion:(void(^)(NSArray *users, NSError *error))completion
{
    FIRDatabaseReference *usersReference = [self.dataBaseReference child:UsersKey];
    
    FIRDatabaseQuery *query = [usersReference queryOrderedByChild:kFirstName];
    
    WEAK_SELF;
    [query observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSDictionary *userData = [snapshot exists] ? snapshot.value : nil;
        
        // GET all values from this dict
        NSArray *mappedUsers = [weakSelf mappedUserProfilesDataFromArray:userData.allValues];
        
        // Filter the data
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fullName CONTAINS[cd] %@ && userId != %@", searchString, self.currentUserId];
        NSArray *filteredArray = [mappedUsers filteredArrayUsingPredicate:predicate];
        
        if (filteredArray && completion) {
            completion(filteredArray, nil);
        } else if (completion) {
            completion(@[], nil);
        }
    }];
}

+ (void)createUpdateUserProfileWithParameters:(NSDictionary *)userProfileParameters
                                 onCompletion:(void(^)(NSError *error))completion
{
    NSString *currentUserId = self.currentUserId;
    FIRDatabaseReference *userReference = [[self.dataBaseReference child:UsersKey] child:currentUserId];

    [userReference observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSMutableDictionary *parameters = [userProfileParameters mutableCopy];
        [parameters setObject:currentUserId forKey:kUserId];
        
        if (snapshot.exists) {
            /**
             *  Update current user because we already have one created
             */
            [userReference updateChildValues:parameters];
        } else {
            /**
             *  Set the current user by his uid (it should be obtained after authorization)
             */
            [userReference setValue:parameters];
        }
        
        [self performProfileChangesRequestWithDisplayName:[NSString stringWithFormat:@"%@ %@", parameters[kFirstName], parameters[kLastName]] photoURL:nil withCompletion:completion];
    }];
}

+ (void)sendFriendsRequestForUserWithId:(NSString *)userId
                           onCompletion:(void(^)(NSError *error))completion
{
    FIRDatabaseReference *requestedFriendsRef = [[self.dataBaseReference child:RequestedFriendsKey] child:self.currentUserId];
    
    [requestedFriendsRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if (snapshot.exists) {
            
            NSMutableArray *requestedFriends = snapshot.value[kRequestedFriendsIds];
            if (![requestedFriends containsObject:userId]) {
                [requestedFriends addObject:userId];
            }
            [requestedFriendsRef updateChildValues:@{kRequestedFriendsIds: requestedFriends}];

        } else {
            
            [requestedFriendsRef setValue:@{kRequestedFriendsIds: @[userId]}];
        }
    }];
}

+ (void)denyFriendsRequestForUserWithId:(NSString *)userId
                           onCompletion:(void(^)(NSError *error))completion
{
    FIRDatabaseReference *requestedFriendsRef = [[self.dataBaseReference child:RequestedFriendsKey] child:self.currentUserId];
    
    [requestedFriendsRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if (snapshot.exists) {
            
            NSMutableArray *requestedFriends = snapshot.value[kRequestedFriendsIds];
            if ([requestedFriends containsObject:userId]) {
                [requestedFriends removeObject:userId];
            }
            
            [requestedFriendsRef updateChildValues:@{kRequestedFriendsIds: requestedFriends}];
        } else {
            
            return;
        }
    }];
}

+ (void)fetchRequestedFriendsIdsOnCompletion:(void(^)(NSArray *requestedFriendsIds))completion
{
    FIRDatabaseReference *requestedFriendsRef = [[self.dataBaseReference child:RequestedFriendsKey] child:self.currentUserId];
    
    [requestedFriendsRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if (snapshot.exists) {
            
            NSArray *requestedFriendsIds = snapshot.value[kRequestedFriendsIds];
            if (completion) {
                completion(requestedFriendsIds);
            }
            
        } else if (completion) {
            
            completion(@[]);
        }
    }];
}

+ (void)fetchRequestedFriendsOnCompletion:(void(^)(NSArray *requestedFriendsIds))completion
{
    FIRDatabaseReference *requestedFriendsRef = [[self.dataBaseReference child:RequestedFriendsKey] child:self.currentUserId];
    
    [requestedFriendsRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if (snapshot.exists) {
            
            NSArray *requestedFriendsIds = snapshot.value[kRequestedFriendsIds];
            
            FIRDatabaseQuery *usersQuery = [[self.dataBaseReference child:UsersKey] queryOrderedByKey];
            
            [usersQuery observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                NSDictionary *userData = [snapshot exists] ? snapshot.value : nil;

                NSArray *mappedUsers = [self mappedUserProfilesDataFromArray:userData.allValues];
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId IN %@", requestedFriendsIds];
                NSArray *requestedFriends = [mappedUsers filteredArrayUsingPredicate:predicate];

                if (completion) {
                    completion(requestedFriends);
                }
            }];
            
        } else if (completion) {
            
            completion(@[]);
        }
    }];
}

/**
 *  Map current user to entity
 *
 *  @param user Dictionary for mapping
 *
 *  @return Current user profile data
 */
+ (HWUserProfileData *)mappedUserProfileDataFromDictionary:(NSDictionary *)user
{
    EKObjectMapping *mapping = [HWUserProfileData defaultMapping];
    HWUserProfileData *mappedUser = [EKMapper objectFromExternalRepresentation:user withMapping:mapping];
    NSTimeInterval dateOfBirthTimeStamp = [user[kDateOfBirth] doubleValue];
    NSDate *dateOfBirth = [NSDate dateWithTimeIntervalSince1970:dateOfBirthTimeStamp];
    [mappedUser setValue:dateOfBirth forKey:kDateOfBirth];
    
    return mappedUser;
}

/**
 *  Map the array of users to entities
 *
 *  @param users Array for mapping
 *
 *  @return Array of mapped entities
 */
+ (NSArray *)mappedUserProfilesDataFromArray:(NSArray *)users
{
    EKObjectMapping *mapping = [HWUserProfileData defaultMapping];
    NSArray *mappedUsers = [EKMapper arrayOfObjectsFromExternalRepresentation:users withMapping:mapping];
    
    [mappedUsers enumerateObjectsUsingBlock:^(HWUserProfileData  *_Nonnull mappedUser, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *rawUserDict = users[idx];
        NSTimeInterval dateOfBirthTimeStamp = [rawUserDict[kDateOfBirth] doubleValue];
        NSDate *dateOfBirth = [NSDate dateWithTimeIntervalSince1970:dateOfBirthTimeStamp];
        [mappedUser setValue:dateOfBirth forKey:kDateOfBirth];
    }];
    
    return mappedUsers;
}

@end
