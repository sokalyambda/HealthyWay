//
//  HWDatabaseManager.h
//  HealthyWay
//
//  Created by Mobindustry on 11/23/15.
//  Copyright © 2015 Mobindustry. All rights reserved.
//

@interface HWDatabaseManager : NSObject

@property (strong, nonatomic, readonly) NSManagedObjectContext *mainContext;
@property (strong, nonatomic, readonly) NSManagedObjectContext *writerContext;

+ (instancetype)sharedManager;

- (BOOL)saveContext;

- (void)deleteManagedObject:(NSManagedObject *)object;
- (void)deleteCollection:(id<NSFastEnumeration>)collection;
- (void)deleteAllObjects:(NSString*)entityDescription;

- (NSManagedObject*)addNewManagedObjectForName:(NSString*)name;
- (NSArray *)getEntities:(NSString *)entityName byPredicate:(NSPredicate *)predicate withSortDescriptors:(NSArray *)sortDescriptors fetchLimit:(NSInteger)fetchLimit andFetchOffset:(NSInteger)fetchOffset;
- (NSArray *)getEntities:(NSString *)entityName byPredicate:(NSPredicate *)predicate withSortDescriptors:(NSArray *)sortDescriptors uniqueObjects:(BOOL)uniqueObjects propertyNames:(NSArray *)propertyNames includesSubentities:(BOOL)includesSubentities;
- (NSArray *)getEntities:(NSString *)entityName byPredicate:(NSPredicate *)predicate withSortDescriptors:(NSArray *)sortDescriptors;
- (NSArray*)getEntities:(NSString*)entityName byPredicate:(NSPredicate*)predicate;
- (NSArray*)getEntities:(NSString*)entityName;

@end
