//
//  HWDatabaseManager.m
//  HealthyWay
//
//  Created by Mobindustry on 11/23/15.
//  Copyright © 2015 Mobindustry. All rights reserved.
//

#import "HWDatabaseManager.h"

@interface HWDatabaseManager()

@property (strong, nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic, readwrite) NSManagedObjectContext *mainContext;
@property (strong, nonatomic, readwrite) NSManagedObjectContext *writerContext;

@end

@implementation HWDatabaseManager

#pragma mark - Lifecycle

+ (instancetype)sharedManager
{
    static HWDatabaseManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HWDatabaseManager alloc] init];
    });
    return manager;
}

#pragma mark - Core Data stack

@synthesize mainContext = _mainContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"HealthyWayDataModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption : @YES,
                              NSInferMappingModelAutomaticallyOption : @YES};
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"HealthyWay.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
       
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"com.database.error" code:1000 userInfo:dict];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)writerContext
{
    if (_writerContext) {
        return _writerContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _writerContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_writerContext setPersistentStoreCoordinator:coordinator];
    return _writerContext;
}

- (NSManagedObjectContext *)mainContext
{
    if (_mainContext) {
        return _mainContext;
    }
    _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _mainContext.parentContext = self.writerContext;

    return _mainContext;
}

#pragma mark - Core Data Saving support

- (BOOL)saveContext
{
    __block NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.mainContext;
    if (managedObjectContext) {
        [managedObjectContext performBlockAndWait:^{
            if ([managedObjectContext save:&error]) {
                DLog(@"Main Context Saved!");
            }
        }];
    }
    
    [self.writerContext performBlock:^{
        if ([self.writerContext save:&error]) {
            DLog(@"Writer Context Saved!");
        };
    }];
    return !error;
}

#pragma mark - Deletion

- (void)deleteManagedObject:(NSManagedObject *)object
{
    [self.mainContext deleteObject:object];
}

- (void)deleteCollection:(id<NSFastEnumeration>)collection
{
    for (NSManagedObject *managedObject in collection) {
        [self.mainContext deleteObject:managedObject];
    }
}

- (void)deleteAllObjects:(NSString *)entityDescription
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:self.mainContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [self.mainContext executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *managedObject in items) {
        [self.mainContext deleteObject:managedObject];
    }
    
    [self saveContext];
}

#pragma mark - Creation

- (NSManagedObject *)addNewManagedObjectForName:(NSString *)name
{
    return [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self.mainContext];
}

#pragma mark - Actions

- (NSArray *)executeRequest:(NSFetchRequest *)fetchRequest
{
    NSArray *managedObjects = nil;
    
    NSError *error = nil;
    @synchronized(self.persistentStoreCoordinator) {
        managedObjects = [self.mainContext executeFetchRequest:fetchRequest error:&error];
        
        if (error) {
            managedObjects = nil;
        }
        return managedObjects;
    }
}

- (NSArray *)getEntities:(NSString *)entityName byPredicate:(NSPredicate *)predicate withSortDescriptors:(NSArray *)sortDescriptors uniqueObjects:(BOOL)uniqueObjects propertyNames:(NSArray *)propertyNames includesSubentities:(BOOL)includesSubentities
{
    return [self getEntities:entityName
                 byPredicate:predicate
         withSortDescriptors:sortDescriptors
               uniqueObjects:uniqueObjects
               propertyNames:propertyNames
                  fetchLimit:0
              andFetchOffset:0
         includesSubentities:includesSubentities];
}

- (NSArray *)getEntities:(NSString *)entityName
             byPredicate:(NSPredicate *)predicate
     withSortDescriptors:(NSArray *)sortDescriptors
           uniqueObjects:(BOOL)uniqueObjects
           propertyNames:(NSArray *)propertyNames
              fetchLimit:(NSInteger)fetchLimit
          andFetchOffset:(NSInteger)fetchOffset
     includesSubentities:(BOOL)includesSubentities {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];

    if (uniqueObjects) {
        [fetchRequest setResultType:NSDictionaryResultType];
        [fetchRequest setReturnsDistinctResults:uniqueObjects];
        fetchRequest.propertiesToFetch = propertyNames;
    }
    
    if (predicate) {
        [fetchRequest setPredicate:predicate];
    }
    if (sortDescriptors) {
        [fetchRequest setSortDescriptors:sortDescriptors];
    }
    if (fetchLimit > 0) {
        fetchRequest.fetchLimit = fetchLimit;
    }
    if (fetchOffset > 0) {
        fetchRequest.fetchOffset = fetchOffset;
    }
    
    fetchRequest.includesSubentities = includesSubentities;
    
    NSArray *items = [self executeRequest:fetchRequest];
    
    if (items.count) {
        return items;
    }
    
    return nil;
    
}

- (NSArray *)getEntities:(NSString *)entityName
             byPredicate:(NSPredicate *)predicate
     withSortDescriptors:(NSArray *)sortDescriptors
              fetchLimit:(NSInteger)fetchLimit
          andFetchOffset:(NSInteger)fetchOffset
{
    return [self getEntities:entityName
                 byPredicate:predicate
         withSortDescriptors:sortDescriptors
               uniqueObjects:NO
               propertyNames:nil
                  fetchLimit:fetchLimit
              andFetchOffset:fetchOffset
         includesSubentities:YES];
}

- (NSArray *)getEntities:(NSString *)entityName
             byPredicate:(NSPredicate *)predicate
     withSortDescriptors:(NSArray *)sortDescriptors
{
   return [self getEntities:entityName
                byPredicate:predicate
        withSortDescriptors:sortDescriptors
              uniqueObjects:NO
              propertyNames:nil
                 fetchLimit:0
             andFetchOffset:0
        includesSubentities:NO];
}

- (NSArray *)getEntities:(NSString *)entityName
             byPredicate:(NSPredicate *)predicate
{
    return [self getEntities:entityName
                 byPredicate:predicate
         withSortDescriptors:nil
                  fetchLimit:0
              andFetchOffset:0];
}

- (NSArray*)getEntities:(NSString*)entityName
{
    return [self getEntities:entityName
                 byPredicate:nil];
}

@end
