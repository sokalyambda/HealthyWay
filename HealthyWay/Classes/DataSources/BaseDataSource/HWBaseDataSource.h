//
//  HWBaseDataSource.h
//  HealthyWay
//
//  Created by Eugenity on 23.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

typedef NS_ENUM(NSUInteger, HWDataSourceType) {
    HWDataSourceTypeAddFriends,
    HWDataSourceTypeFriends
};

typedef void(^HWResultHandler)(id resultData);

@interface HWBaseDataSource : NSObject<UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating>

@property (strong, nonatomic, readonly) UISearchController *searchController;

@property (strong, nonatomic, readonly) NSArray *dataSourceArray;

@property (strong, nonatomic, readonly) UITableView *tableView;

@property (copy, nonatomic, readonly) HWResultHandler resultDataHandler;

+ (instancetype)dataSourceWithType:(HWDataSourceType)dataSourceType
                      forTableView:(UITableView *)tableView;

+ (instancetype)dataSourceWithType:(HWDataSourceType)dataSourceType
                      forTableView:(UITableView *)tableView
                  searchController:(UISearchController *)searchController;

- (void)performNeededUpdatingActionsWithCompletion:(HWResultHandler)completion;

@end
