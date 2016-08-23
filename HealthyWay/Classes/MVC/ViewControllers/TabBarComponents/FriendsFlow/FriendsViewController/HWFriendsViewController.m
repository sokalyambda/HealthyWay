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

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupDataSource];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.friendsDataSource performNeededUpdatingActions];
}

#pragma mark - Actions

- (void)setupDataSource
{
    self.friendsDataSource = [HWBaseDataSource dataSourceWithType:HWDataSourceTypeFriends
                                                     forTableView:self.tableView];
    
}

@end
