//
//  HWBaseAppManager.h
//  HealthyWay
//
//  Created by Eugenity on 28.06.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

@interface HWBaseAppManager : NSObject

@property (strong, nonatomic, readonly) FIRUser *currentUser;
@property (strong, nonatomic, readonly) FIRAuth *currentAuth;

+ (instancetype)sharedManager;

- (void)signOutIfFirstLaunch;

@end
