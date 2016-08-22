//
//  HWFriendsDataSource.h
//  HealthyWay
//
//  Created by Anastasia Mark on 17.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

@interface HWFriendsDataSource : NSObject<UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating>

@property (nonatomic, readonly) UISearchController *searchController;

- (instancetype)initWithSearchController:(UISearchController *)searchController
                        resultsTableView:(UITableView *)tableView;

@end
