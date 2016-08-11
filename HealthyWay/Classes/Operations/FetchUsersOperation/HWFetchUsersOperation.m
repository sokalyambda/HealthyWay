//
//  HWFetchUsersOperation.m
//  HealthyWay
//
//  Created by Eugenity on 11.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWFetchUsersOperation.h"

#import "HWUserProfileData+Mapping.h"

static NSString *const kFirstName       = @"firstName";
static NSString *const kDateOfBirth     = @"dateOfBirth";

@interface HWFetchUsersOperation ()

@property (strong, nonatomic, readwrite) NSError *error;

@property (assign, nonatomic) HWFetchUsersOperationType fetchingType;

@property (strong, nonatomic, readwrite) NSArray<id<HWUserProfile>> *users;

@end

@implementation HWFetchUsersOperation

@synthesize error = _error;

#pragma mark - Lifecycle

- (instancetype)initWithFetchingType:(HWFetchUsersOperationType)fetchingType
{
    self = [super init];
    if (self) {
        _fetchingType = fetchingType;
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
    
    [self fetchUsers];
}

- (void)fetchUsers
{
    FIRUser *user = [HWBaseAppManager sharedManager].currentUser;
    FIRDatabaseReference *usersReference = [[HWBaseAppManager sharedManager].dataBaseReference child:UsersKey];
    
    if (self.isCancelled) {
        return [self finish:YES];
    }
    
    WEAK_SELF;
    switch (self.fetchingType) {
        case HWFetchUsersOperationTypeAll: {
            FIRDatabaseQuery *allUsersSortedByFirstNameQuery = [usersReference queryOrderedByChild:kFirstName];
            [allUsersSortedByFirstNameQuery observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                
                if (weakSelf.isCancelled) {
                    return [self finish:YES];
                }
                
                DLog(@"here is the all users");
            }];
            break;
        }
        case HWFetchUsersOperationTypeCurrent: {
            FIRDatabaseQuery *currentUserQuery = [[usersReference queryOrderedByKey] queryEqualToValue:user.uid];
            [currentUserQuery observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                
                if (weakSelf.isCancelled) {
                    return [self finish:YES];
                }
                
                NSDictionary *userData = [snapshot exists] ? snapshot.value[user.uid] : nil;
                HWUserProfileData *currentUserProfile = [weakSelf mappedUserProfileDataFromDictionary:userData];
                if (currentUserProfile) {
                    weakSelf.users = @[currentUserProfile];
                }
                [[HWBaseAppManager sharedManager] setUserProfileData:currentUserProfile];
                
                [weakSelf completeTheExecution];
                DLog(@"here is the current user");
            }];
            break;
        }
    }
    
}

/*
- (NSArray *)mappedUsersFromDictionary:(NSDictionary *)users
{
    EKObjectMapping *mapping = [HWUserProfileData defaultMapping];
    NSArray *mappedUsers = [EKMapper arrayOfObjectsFromExternalRepresentation:users withMapping:mapping];
    return mappedUsers;
}
 */

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
