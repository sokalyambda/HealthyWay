//
//  HWBaseAppManager.h
//  HealthyWay
//
//  Created by Eugenity on 28.06.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

@class HWUserProfileData;

@interface HWBaseAppManager : NSObject

@property (strong, nonatomic, readonly) FIRUser *currentUser;
@property (strong, nonatomic, readonly) FIRAuth *currentAuth;
@property (strong, nonatomic, readonly) FIRDatabaseReference *dataBaseReference;

@property (strong, nonatomic, readonly) HWUserProfileData *userProfileData;
- (void)setUserProfileData:(HWUserProfileData *)userProfileData;

+ (instancetype)sharedManager;

- (void)signOutIfFirstLaunch;

@end
