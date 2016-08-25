//
//  HWUserProfilesTasksFactory.m
//  HealthyWay
//
//  Created by Eugenity on 25.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWUserProfilesTasksFactory.h"

#import "HWFetchUsersTask.h"
#import "HWCreateUpdateUserProfileTask.h"

@implementation HWUserProfilesTasksFactory

#pragma mark - HWTasksAbstractFactory

- (id<HWTask>)taskWithType:(HWTaskType)taskType
             andParameters:(NSDictionary *)parameters
{
    switch (taskType) {
        case HWTaskTypeFetchUsers:
            
            return [[HWFetchUsersTask alloc] initWithUsersFetchingType:[parameters[TaskKeyUsersFetchingType] integerValue]
                                                          searchString:parameters[TaskKeyUsersSearchString]];
        case HWTaskTypeCreateUpdateUserProfile:
            return [[HWCreateUpdateUserProfileTask alloc] initWithFirstName:parameters[TaskKeyFirstName]
                                                                   lastName:parameters[TaskKeyLastName]
                                                                   nickName:parameters[TaskKeyNickName]
                                                                dateOfBirth:parameters[TaskKeyDateOfBirthName]
                                                                 avatarData:parameters[TaskKeyAvatarData]
                                                                     isMale:parameters[TaskKeyIsMale]];;
            
        default:
            return nil;
            
    }
}

@end
