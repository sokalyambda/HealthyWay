//
//  HWFriendsViewController.m
//  HealthyWay
//
//  Created by Eugenity on 12.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWFriendsViewController.h"

#import "HWBaseDataSource.h"

@interface HWFriendsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) HWBaseDataSource *friendsDataSource;

@end

@implementation HWFriendsViewController

#pragma mark - Accessors

- (HWBaseDataSource *)friendsDataSource {
    if (!_friendsDataSource) {
        _friendsDataSource = [HWBaseDataSource dataSourceWithType:HWDataSourceTypeFriends
                                                     forTableView:self.tableView];
    }
    return _friendsDataSource;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self showProgressHud];
    WEAK_SELF;
    [self.friendsDataSource performNeededUpdatingActionsWithCompletion:^(id resultData) {
        [weakSelf hideProgressHud];
    }];
}

@end
