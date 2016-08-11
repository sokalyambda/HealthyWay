//
//  ManagedUserProfileData+CoreDataProperties.h
//  HealthyWay
//
//  Created by Eugenity on 11.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ManagedUserProfileData.h"

#import "HWUserProfile.h"

NS_ASSUME_NONNULL_BEGIN

@interface ManagedUserProfileData (CoreDataProperties)<HWUserProfile>

@property (nullable, nonatomic, retain) NSString *avatarBase64;
@property (nullable, nonatomic, retain) NSDate *dateOfBirth;
@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSNumber *isMale;
@property (nullable, nonatomic, retain) NSString *lastName;
@property (nullable, nonatomic, retain) NSString *nickName;

@end

NS_ASSUME_NONNULL_END
