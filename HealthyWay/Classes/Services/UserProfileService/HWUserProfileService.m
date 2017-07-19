//
//  HWUserProfileService.m
//  HealthyWay
//
//  Created by Eugenity on 12.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWUserProfileService.h"

#import "HWUserProfileData+Mapping.h"

static NSString *const kFirstName            = @"firstName";
static NSString *const kLastName             = @"lastName";
static NSString *const kDateOfBirth          = @"dateOfBirth";
static NSString *const kUserId               = @"userId";
static NSString *const kRequestedFriendsIds  = @"requestedFriendsIds";
static NSString *const kRequestingFriendsIds = @"requestingFriendsIds";
static NSString *const kExistedFriendsIds    = @"existedFriendsIds";

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
            
            if (currentUserProfile) {
                [self p_fetchAvatarsForUsers:@[currentUserProfile] withCompletion:^{
                    if (currentUserProfile && completion) {
                        completion(@[currentUserProfile], nil);
                    } else if (completion) {
                        completion(@[], nil);
                    }
                }];
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
        
        [self p_fetchAvatarsForUsers:filteredArray withCompletion:^{
            if (filteredArray && completion) {
                completion(filteredArray, nil);
            } else if (completion) {
                completion(@[], nil);
            }
        }];
        
    }];
}

+ (void)fetchUsersDataExceptExistedFriendsWithSearchString:(NSString *)searchString
                                              onCompletion:(void(^)(NSArray *users, NSError *error))completion
{
    FIRDatabaseReference *usersReference = [self.dataBaseReference child:UsersKey];
    
    FIRDatabaseQuery *query = [usersReference queryOrderedByChild:kFirstName];
    
    WEAK_SELF;
    [self fetchExistedFriendsOnCompletion:^(NSArray *existedFriends) {
        [query observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            
            NSDictionary *userData = [snapshot exists] ? snapshot.value : nil;
            
            // GET all values from this dict
            NSArray *mappedUsers = [weakSelf mappedUserProfilesDataFromArray:userData.allValues];
            
            // Filter the data
            NSArray *existedFriendIds = [existedFriends valueForKeyPath:@"userId"];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fullName CONTAINS[cd] %@ && userId != %@ && (NOT userId IN %@)", searchString, self.currentUserId, existedFriendIds];
            NSArray *filteredArray = [mappedUsers filteredArrayUsingPredicate:predicate];
            
            [self p_fetchAvatarsForUsers:filteredArray withCompletion:^{
                if (filteredArray && completion) {
                    completion(filteredArray, nil);
                } else if (completion) {
                    completion(@[], nil);
                }
            }];
            
        }];
    }];
}

+ (void)createUpdateUserProfileWithParameters:(NSDictionary *)userProfileParameters
                                andAvatarData:(NSData *)data
                                 onCompletion:(void(^)(NSError *error))completion
{
    NSString *currentUserId = self.currentUserId;
    FIRDatabaseReference *userReference = [[self.dataBaseReference child:UsersKey] child:currentUserId];

    [userReference observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSMutableDictionary *parameters = [userProfileParameters mutableCopy];
        [parameters setObject:currentUserId forKey:kUserId];
        
        // Create storage reference
        FIRStorage *storage = [FIRStorage storage];
        // Create a storage reference from our storage service
        FIRStorageReference *storageRef = [storage referenceForURL:StorageReferense];
        
        FIRStorageReference *userAvatarRef = [storageRef child:[NSString stringWithFormat:@"%@/%@.jpg", AvatarsKey, parameters[kUserId]]];
        FIRStorageUploadTask *uploadTask = [userAvatarRef putData:data metadata:nil completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
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
            
            [self performProfileChangesRequestWithDisplayName:[NSString stringWithFormat:@"%@ %@", parameters[kFirstName], parameters[kLastName]] photoURL:metadata.downloadURL withCompletion:completion];
        }];
    }];
}

+ (void)sendFriendsRequestForUserWithId:(NSString *)userId
                           onCompletion:(void(^)(NSError *error))completion
{
    FIRDatabaseReference *requestedFriendsRef = [[self.dataBaseReference child:RequestedFriendsKey] child:self.currentUserId];
    FIRDatabaseReference *requestingFriendsRef = [[self.dataBaseReference child:RequestingFriendsKey] child:userId];
    
    dispatch_group_t sendRequestGroup = dispatch_group_create();
    
    dispatch_group_enter(sendRequestGroup);
    [requestedFriendsRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        if (snapshot.exists) {
            NSMutableArray *requestedFriends = snapshot.value[kRequestedFriendsIds];
            
            if (requestedFriends) {
                if (![requestedFriends containsObject:userId]) {
                    [requestedFriends addObject:userId];
                }
                [requestedFriendsRef updateChildValues:@{kRequestedFriendsIds: requestedFriends}];
            } else {
                [requestedFriendsRef setValue:@{kRequestedFriendsIds: @[userId]}];
            }

        } else {
            [requestedFriendsRef setValue:@{kRequestedFriendsIds: @[userId]}];
        }
        dispatch_group_leave(sendRequestGroup);
    }];
    
    dispatch_group_enter(sendRequestGroup);
    [requestingFriendsRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        if (snapshot.exists) {
            
            NSMutableArray *requestingFriendsIds = snapshot.value[kRequestingFriendsIds];
            
            if (requestingFriendsIds) {
                if (![requestingFriendsIds containsObject:self.currentUserId]) {
                    [requestingFriendsIds addObject:self.currentUserId];
                }
                [requestingFriendsRef updateChildValues:@{kRequestingFriendsIds: requestingFriendsIds}];
            } else {
                [requestingFriendsRef setValue:@{kRequestingFriendsIds: @[self.currentUserId]}];
            }
            
        } else {
            [requestingFriendsRef setValue:@{kRequestingFriendsIds: @[self.currentUserId]}];
        }
        
        dispatch_group_leave(sendRequestGroup);
    }];
    
    dispatch_group_notify(sendRequestGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        if (completion) {
            completion(nil);
        }
    });
}

+ (void)denyFriendsRequestForUserWithId:(NSString *)userId
                           onCompletion:(void(^)(NSError *error))completion
{
    FIRDatabaseReference *requestedFriendsRef = [[self.dataBaseReference child:RequestedFriendsKey] child:self.currentUserId];
    FIRDatabaseReference *requestingFriendsRef = [[self.dataBaseReference child:RequestingFriendsKey] child:userId];
    
    dispatch_group_t denyFriendGroup = dispatch_group_create();
    
    dispatch_group_enter(denyFriendGroup);
    [requestedFriendsRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if (snapshot.exists) {
            
            NSMutableArray *requestedFriends = snapshot.value[kRequestedFriendsIds];
            
            if (requestedFriends) {
                if ([requestedFriends containsObject:userId]) {
                    [requestedFriends removeObject:userId];
                }
                
                [requestedFriendsRef updateChildValues:@{kRequestedFriendsIds: requestedFriends}];
            }
        }
        
        dispatch_group_leave(denyFriendGroup);
    }];
    
    dispatch_group_enter(denyFriendGroup);
    [requestingFriendsRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if (snapshot.exists) {
            
            NSMutableArray *requestingFriendsIds = snapshot.value[kRequestingFriendsIds];
            
            if (requestingFriendsIds) {
                if ([requestingFriendsIds containsObject:self.currentUserId]) {
                    [requestingFriendsIds removeObject:self.currentUserId];
                }
                
                [requestedFriendsRef updateChildValues:@{kRequestingFriendsIds: requestingFriendsIds}];
            }
        }
        
        dispatch_group_leave(denyFriendGroup);
    }];
    
    dispatch_group_notify(denyFriendGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        if (completion) {
            completion(nil);
        }
    });
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

+ (void)fetchRequestedFriendsOnCompletion:(void(^)(NSArray *requestedFriends))completion
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

                [self p_fetchAvatarsForUsers:requestedFriends withCompletion:^{
                    if (completion) {
                        completion(requestedFriends);
                    }
                }];
            }];
            
        } else if (completion) {
            
            completion(@[]);
        }
    }];
}

+ (void)fetchRequestingFriendsOnCompletion:(void(^)(NSArray *requestingFriends))completion
{
    FIRDatabaseReference *requestingFriendsRef = [[self.dataBaseReference child:RequestingFriendsKey] child:self.currentUserId];
    
    [requestingFriendsRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if (snapshot.exists) {
            
            NSArray *requestingFriendsIds = snapshot.value[kRequestingFriendsIds];
            
            FIRDatabaseQuery *usersQuery = [[self.dataBaseReference child:UsersKey] queryOrderedByKey];
            
            [usersQuery observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                NSDictionary *userData = [snapshot exists] ? snapshot.value : nil;
                
                NSArray *mappedUsers = [self mappedUserProfilesDataFromArray:userData.allValues];
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId IN %@", requestingFriendsIds];
                NSArray *requestedFriends = [mappedUsers filteredArrayUsingPredicate:predicate];
                
                [self p_fetchAvatarsForUsers:requestedFriends withCompletion:^{
                    if (completion) {
                        completion(requestedFriends);
                    }
                }];
            }];
            
        } else if (completion) {
            
            completion(@[]);
        }
    }];
}

+ (void)fetchExistedFriendsOnCompletion:(void(^)(NSArray *existedFriends))completion
{
    FIRDatabaseReference *existedFriendsRef = [[self.dataBaseReference child:ExistedFriendsKey] child:self.currentUserId];
    
    [existedFriendsRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if (snapshot.exists) {
            
            NSArray *existedFriendsIds = snapshot.value[kExistedFriendsIds];
            
            FIRDatabaseQuery *usersQuery = [[self.dataBaseReference child:UsersKey] queryOrderedByKey];
            
            [usersQuery observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                NSDictionary *userData = [snapshot exists] ? snapshot.value : nil;
                
                NSArray *mappedUsers = [self mappedUserProfilesDataFromArray:userData.allValues];
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId IN %@", existedFriendsIds];
                NSArray *existedFriends = [mappedUsers filteredArrayUsingPredicate:predicate];
                
                [self p_fetchAvatarsForUsers:existedFriends withCompletion:^{
                    if (completion) {
                        completion(existedFriends);
                    }
                }];
            }];
            
        } else if (completion) {
            
            completion(@[]);
        }
    }];
}

+ (void)addUserToFriendsWithId:(NSString *)userId onCompletion:(void(^)(NSError *error))completion
{
    __block NSError *error = nil;
    
    FIRDatabaseReference *friendsRef = [[self.dataBaseReference child:ExistedFriendsKey] child:self.currentUserId];
    FIRDatabaseReference *userFriendsRef = [[self.dataBaseReference child:ExistedFriendsKey] child:userId];
    FIRDatabaseReference *requestingFriendsRef = [[self.dataBaseReference child:RequestingFriendsKey] child:self.currentUserId];
    FIRDatabaseReference *userRequestedFriendsRef = [[self.dataBaseReference child:RequestedFriendsKey] child:userId];
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    // Add userId to current user's existed friends
    [friendsRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if (snapshot.exists) {
            
            NSArray *existedFriendsIds = snapshot.value[kExistedFriendsIds];
            
            if (existedFriendsIds) {
                if (![existedFriendsIds containsObject:userId]) {
                    NSMutableArray *mutableIds = [NSMutableArray arrayWithArray:existedFriendsIds];
                    [mutableIds addObject:userId];
                    [friendsRef updateChildValues:@{kExistedFriendsIds: [NSArray arrayWithArray:mutableIds]}];
                }
                
                dispatch_group_leave(group);
            } else {
                NSArray *existedFriendsIds = @[userId];
                [friendsRef setValue:@{kExistedFriendsIds: existedFriendsIds}];
                
                dispatch_group_leave(group);
            }
        } else {
            NSArray *existedFriendsIds = @[userId];
            [friendsRef setValue:@{kExistedFriendsIds: existedFriendsIds}];
            
            dispatch_group_leave(group);
        }
    }];
    
    dispatch_group_enter(group);
    // Add self.currentUserId to user's (with userId) existedFriends
    [userFriendsRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if (snapshot.exists) {

            NSArray *existedFriendsIds = snapshot.value[kExistedFriendsIds];
            
            if (existedFriendsIds) {
                
                if (![existedFriendsIds containsObject:self.currentUserId]) {
                    NSMutableArray *mutableIds = [NSMutableArray arrayWithArray:existedFriendsIds];
                    [mutableIds addObject:self.currentUserId];
                    [userFriendsRef updateChildValues:@{kExistedFriendsIds: mutableIds}];
                }
                
                dispatch_group_leave(group);
            } else {
                NSArray *existedFriendsIds = @[self.currentUserId];
                [userFriendsRef setValue:@{kExistedFriendsIds: existedFriendsIds}];
                
                dispatch_group_leave(group);
            }
        } else {
            NSArray *existedFriendsIds = @[self.currentUserId];
            [userFriendsRef setValue:@{kExistedFriendsIds: existedFriendsIds}];
            
            dispatch_group_leave(group);
        }
    }];
    
    dispatch_group_enter(group);
    // 1) Remove userId from requesting friends ids of current user
    [requestingFriendsRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if (snapshot.exists) {
            NSArray *requestingFriendsIds = snapshot.value[kRequestingFriendsIds];
            if ([requestingFriendsIds containsObject:userId]) {
                NSMutableArray *mutableIds = [NSMutableArray arrayWithArray:requestingFriendsIds];
                [mutableIds removeObject:userId];
                [requestingFriendsRef updateChildValues:@{kRequestingFriendsIds: [NSArray arrayWithArray:mutableIds]}];
                
                dispatch_group_leave(group);
            } else {
                error = [NSError errorWithDomain:@"com.healthyway" code:9998 userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"%@: %@", LOCALIZED(@"User with userId not found in requesting friends of current user"), userId]}];
                dispatch_group_leave(group);
            }
        } else {
            error = [NSError errorWithDomain:@"com.healthyway" code:9997 userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"%@: %@", LOCALIZED(@"No requesting friends for current user"), self.currentUserId]}];
            dispatch_group_leave(group);
        }
    }];
    
    dispatch_group_enter(group);
    // 2) Remove self.currentFriendId from requested friends ids of user with userId
    [userRequestedFriendsRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if (snapshot.exists) {
            NSArray *userRequestedFriendsIds = snapshot.value[kRequestedFriendsIds];
            if ([userRequestedFriendsIds containsObject:self.currentUserId]) {
                NSMutableArray *mutableIds = [NSMutableArray arrayWithArray:userRequestedFriendsIds];
                [mutableIds removeObject:self.currentUserId];
                [userRequestedFriendsRef updateChildValues:@{kRequestedFriendsIds: [NSArray arrayWithArray:mutableIds]}];
                
                dispatch_group_leave(group);
            } else {
                error = [NSError errorWithDomain:@"com.healthyway" code:9996 userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"%@: %@", LOCALIZED(@"Current user is not in the requested friends of user with userId"), userId]}];
                dispatch_group_leave(group);
            }
        } else {
            dispatch_group_leave(group);
            error = [NSError errorWithDomain:@"com.healthyway" code:9995 userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"%@: %@", LOCALIZED(@"No requested friends for user with userId"), userId]}];
        }
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (completion) {
            completion(error);
        }
    });
}

+ (void)declineIncomingFriendsRequestFromUserWithId:(NSString *)userId onCompletion:(void(^)(NSError *error))completion
{
    
}

/**
 In this case we would like to delete user from existed friends. If user's existed friends contain the userId => requestingFriends and requestedFriends arrays are not contained either userId or currentUserId. In other words if users are friends => friends requests are cleared.
 */
+ (void)removeUserFromFriendsWithId:(NSString *)userId onCompletion:(void(^)(NSError *error))completion
{
    
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

+ (void)p_fetchAvatarsForUsers:(NSArray *)users
                withCompletion:(void(^)())completion
{
    // Create storage reference
    FIRStorage *storage = [FIRStorage storage];
    // Create a storage reference from our storage service
    FIRStorageReference *storageRef = [storage referenceForURL:StorageReferense];
    
    dispatch_group_t avatarsGroup = dispatch_group_create();
    
    [users enumerateObjectsUsingBlock:^(HWUserProfileData *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FIRStorageReference *userAvatarRef = [storageRef child:[NSString stringWithFormat:@"%@/%@.jpg", AvatarsKey, obj.userId]];
        dispatch_group_enter(avatarsGroup);
        [userAvatarRef downloadURLWithCompletion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
            obj.avatarURLString = URL.absoluteString;
            dispatch_group_leave(avatarsGroup);
        }];
    }];
    
    dispatch_group_notify(avatarsGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        if (completion) {
            completion();
        }
    });
}

@end
