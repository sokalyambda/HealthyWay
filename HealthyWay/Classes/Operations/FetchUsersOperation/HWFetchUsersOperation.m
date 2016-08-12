//
//  HWFetchUsersOperation.m
//  HealthyWay
//
//  Created by Eugenity on 11.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWFetchUsersOperation.h"

#import "HWUserProfileData+Mapping.h"

static NSString *const kFirstName = @"firstName";

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
    if (self.isCancelled) {
        return [self finish:YES];
    }
    
    WEAK_SELF;
    switch (self.fetchingType) {
        case HWFetchUsersOperationTypeAll: {
//            FIRDatabaseQuery *allUsersSortedByFirstNameQuery = [usersReference queryOrderedByChild:kFirstName];
//            [allUsersSortedByFirstNameQuery observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
//                
//                if (weakSelf.isCancelled) {
//                    return [self finish:YES];
//                }
//                
//                DLog(@"here is the all users");
//            }];
            break;
        }
        case HWFetchUsersOperationTypeCurrent: {

            [[HWBaseAppManager sharedManager] fetchCurrentUserDataWithCompletion:^(NSArray *users, NSError *error) {
                if (weakSelf.isCancelled) {
                    return [self finish:YES];
                }
                weakSelf.users = users;
                weakSelf.error = error;
                
                [weakSelf completeTheExecution];
                
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

@end
