//
//  HWFriendsDataSource.m
//  HealthyWay
//
//  Created by Eugenity on 22.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

typedef NS_ENUM(NSUInteger, HWFriendsDataSourceSection) {
    HWFriendsDataSourceSectionRequestedFriends,
    HWFriendsDataSourceSectionAcceptedFriends
};

#import "HWFriendsDataSource.h"

#import "HWFriendCell.h"

@interface HWFriendsDataSource ()

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *requestedFriendsIds;

@end

@implementation HWFriendsDataSource

#pragma mark - Lifecycle

- (instancetype)initWithTableView:(UITableView *)tableView
{
    self = [super init];
    if (self) {
        _tableView = tableView;
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return HWFriendsDataSourceSectionAcceptedFriends + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case HWFriendsDataSourceSectionRequestedFriends: {
            break;
        }
        case HWFriendsDataSourceSectionAcceptedFriends: {
            break;
        }
            
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
