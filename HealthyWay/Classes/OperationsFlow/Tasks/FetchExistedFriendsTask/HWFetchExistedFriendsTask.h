//
//  HWFetchExistedFriendsTask.h
//  HealthyWay
//
//  Created by se on 19/07/2017.
//  Copyright © 2017 Eugenity. All rights reserved.
//

#import "HWBaseTask.h"

/**
 This task is fetching existed friends of ME
 */
@interface HWFetchExistedFriendsTask : HWBaseTask

@property (strong, nonatomic, readonly) NSArray *existedFriends;

@end
