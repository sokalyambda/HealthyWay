//
//  HWFetchRequestingFriendsTask.h
//  HealthyWay
//
//  Created by Eugenity on 22.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWBaseTask.h"

/**
 *  This task is needed for fetching the users who want to be a friend with ME;
 */
@interface HWFetchRequestingFriendsTask : HWBaseTask

@property (strong, nonatomic, readonly) NSArray *requestingFriends;

@end
