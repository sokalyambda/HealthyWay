//
//  HWBaseDataSource.m
//  HealthyWay
//
//  Created by Eugenity on 23.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWBaseDataSource.h"

#import "HWFriendsDataSource.h"
#import "HWAddFriendsDataSource.h"

@interface HWBaseDataSource ()

@property (strong, nonatomic, readwrite) UITableView *tableView;

@property (strong, nonatomic, readwrite) NSArray *dataSourceArray;

@property (strong, nonatomic, readwrite) UISearchController *searchController;

@end

@implementation HWBaseDataSource

#pragma mark - Accessors

- (void)setResultDataHandler:(HWResultHandler)resultDataHandler
{
    _resultDataHandler = resultDataHandler;
}

- (void)setTableView:(UITableView *)tableView
{
    _tableView = tableView;
    
    [self adjustTableView];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self performNeededUpdatingActionsWithCompletion:nil];
}

#pragma mark - Lifecycle

+ (instancetype)dataSourceWithType:(HWDataSourceType)dataSourceType
                      forTableView:(UITableView *)tableView
{
    HWBaseDataSource *dataSource = nil;
    
    switch (dataSourceType) {
        case HWDataSourceTypeFriends: {
            dataSource = [[HWFriendsDataSource alloc] init];
            break;
        }
        case HWDataSourceTypeAddFriends: {
            dataSource = [[HWAddFriendsDataSource alloc] init];
            break;
        }
    }
    dataSource.tableView = tableView;
    return dataSource;
}

+ (instancetype)dataSourceWithType:(HWDataSourceType)dataSourceType
                      forTableView:(UITableView *)tableView
               searchController:(UISearchController *)searchController
{
    HWBaseDataSource *dataSource = [self dataSourceWithType:dataSourceType forTableView:tableView];
    
    if (dataSource) {
        dataSource.searchController = searchController;
        dataSource.searchController.searchResultsUpdater = dataSource;
    }
    
    return dataSource;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self tableViewCellForIndexPath:indexPath];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Actions

- (void)performNeededUpdatingActionsWithCompletion:(HWResultHandler)completion
{
    _resultDataHandler = completion;
}

//Abstract
- (UITableViewCell *)tableViewCellForIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

//Abstract
- (void)registerNibs
{
    return;
}

- (void)adjustTableView
{
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self registerNibs];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
}

@end
