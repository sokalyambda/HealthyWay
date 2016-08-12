//
//  HWUserProfileService.m
//  HealthyWay
//
//  Created by Eugenity on 12.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWUserProfileService.h"

#import "HWUserProfileData+Mapping.h"

static NSString *const kFirstName   = @"firstName";
static NSString *const kLastName    = @"lastName";
static NSString *const kDateOfBirth = @"dateOfBirth";

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

+ (void)createUpdateUserProfileWithParameters:(NSDictionary *)userProfileParameters
                                 onCompletion:(void(^)(NSError *error))completion
{
    NSString *currentUserId = self.currentUserId;
    FIRDatabaseReference *userReference = [[self.dataBaseReference child:UsersKey] child:currentUserId];
    
    [userReference observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        if (snapshot.exists) {
            /**
             *  Update current user because we already have one created
             */
            [[[self.dataBaseReference child:UsersKey] child:currentUserId] updateChildValues:userProfileParameters];
        } else {
            /**
             *  Set the current user by his uid (it should be obtained after authorization)
             */
            [[[self.dataBaseReference child:UsersKey] child:currentUserId] setValue:userProfileParameters];
        }
        
        [self performProfileChangesRequestWithDisplayName:[NSString stringWithFormat:@"%@ %@", userProfileParameters[kFirstName], userProfileParameters[kLastName]] photoURL:nil withCompletion:completion];
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
    [mappedUser setValue:dateOfBirth forKey:@"dateOfBirth"];
    
    return mappedUser;
}

@end
