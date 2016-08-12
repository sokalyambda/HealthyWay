//
//  HWBaseAppManager.h
//  HealthyWay
//
//  Created by Eugenity on 28.06.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

@class HWUserProfileData;

@interface HWBaseAppManager : NSObject

@property (strong, nonatomic, readonly) HWUserProfileData *userProfileData;
- (void)setUserProfileData:(HWUserProfileData *)userProfileData;

+ (instancetype)sharedManager;

@end
