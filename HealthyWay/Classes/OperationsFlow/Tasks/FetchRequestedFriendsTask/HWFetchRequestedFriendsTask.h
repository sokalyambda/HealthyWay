//
//  HWFetchRequestedFriendsTask.h
//  HealthyWay
//
//  Created by Eugenity on 22.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWBaseTask.h"

/**
 *  This task is needed for fetching the users I want to be a friend with;
 */
@interface HWFetchRequestedFriendsTask : HWBaseTask

- (instancetype)initWithFetchType:(HWFetchRequestedFriendsTaskType)type;

@end
