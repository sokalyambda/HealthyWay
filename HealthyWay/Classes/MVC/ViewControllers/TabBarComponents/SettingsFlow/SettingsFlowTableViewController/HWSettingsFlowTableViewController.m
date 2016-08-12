//
//  HWSettingsFlowTableViewController.m
//  HealthyWay
//
//  Created by Anastasia Mark on 12.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWSettingsFlowTableViewController.h"

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
    
}

@end
