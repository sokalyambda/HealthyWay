//
//  HWSettingsFlowTableViewController.m
//  HealthyWay
//
//  Created by Anastasia Mark on 12.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWSettingsFlowTableViewController.h"

typedef enum : NSUInteger {
    HWSettingsFlowTableViewCellTypeChangeEmaile,
    HWSettingsFlowTableViewCellTypeChangePassword,
} HWSettingsFlowTableViewCellType;

@interface HWSettingsFlowTableViewController ()

@end

@implementation HWSettingsFlowTableViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == HWSettingsFlowTableViewCellTypeChangeEmaile) {
        DLog(@"%lu", (unsigned long)HWSettingsFlowTableViewCellTypeChangeEmaile);
    } else if (indexPath.row == HWSettingsFlowTableViewCellTypeChangePassword) {
        DLog(@"%lu", (unsigned long)HWSettingsFlowTableViewCellTypeChangePassword);
    }
    
}

@end
