//
//  HWCoreDataStorage.m
//  HealthyWay
//
//  Created by Eugenity on 03.12.15.
//  Copyright © 2015 Mobindustry. All rights reserved.
//

#import "HWCoreDataStorage.h"

#import "HWDatabaseManager.h"

@implementation HWCoreDataStorage

#pragma mark - Accessors

+ (NSManagedObjectContext *)mainManagedObjectsContext
{
    return [HWDatabaseManager sharedManager].mainContext;
}

+ (NSManagedObjectContext *)backgroundManagedObjectsContext
{
    return [HWDatabaseManager sharedManager].writerContext;
}

+ (HWDatabaseManager *)coreDataManager
{
    return [HWDatabaseManager sharedManager];
}

+ (void)resetChanges
{
    [[self mainManagedObjectsContext] rollback];
    [self saveContext];
}

#pragma mark - Clear Data Base

+ (void)clearDataBase
{

}

#pragma mark - Actions

+ (void)saveContext
{
    [self.coreDataManager saveContext];
}

+ (void)removeObject:(NSManagedObject *)managedObject
{
    [self.coreDataManager deleteManagedObject:managedObject];
    [self saveContext];
}

@end
