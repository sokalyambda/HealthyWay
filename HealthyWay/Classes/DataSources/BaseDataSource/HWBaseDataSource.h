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

@interface HWBaseDataSource : NSObject<UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating>

@property (strong, nonatomic, readonly) UISearchController *searchController;

@property (strong, nonatomic, readonly) NSArray *dataSourceArray;

@property (strong, nonatomic, readonly) UITableView *tableView;

+ (instancetype)dataSourceWithType:(HWDataSourceType)dataSourceType
                      forTableView:(UITableView *)tableView;

+ (instancetype)dataSourceWithType:(HWDataSourceType)dataSourceType
                      forTableView:(UITableView *)tableView
               andSearchController:(UISearchController *)searchController;

- (void)performNeededUpdatingActions;

@end
