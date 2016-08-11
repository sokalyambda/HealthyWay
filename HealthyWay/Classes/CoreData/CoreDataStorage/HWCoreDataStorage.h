//
//  HWCoreDataStorage.h
//  HealthyWay
//
//  Created by Eugenity on 03.12.15.
//  Copyright © 2015 Mobindustry. All rights reserved.
//

@interface HWCoreDataStorage : NSObject

+ (NSManagedObjectContext *)mainManagedObjectsContext;
+ (NSManagedObjectContext *)backgroundManagedObjectsContext;

+ (void)saveContext;

+ (void)resetChanges;

// MARK: Clear data base
+ (void)clearDataBase;

@end
