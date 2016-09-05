//
//  HWSettingsFlowTableViewController.m
//  HealthyWay
//
//  Created by Anastasia Mark on 12.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWSettingsFlowTableViewController.h"

//#import "HWSettingsContainerController.h"

#import "HWChangeEmailController.h"
#import "HWChangePasswordController.h"

typedef enum : NSUInteger {
    HWSettingsFlowTableViewCellTypeChangePassword,
    HWSettingsFlowTableViewCellTypeChangeEmail,
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
    
    switch (indexPath.row) {
        case HWSettingsFlowTableViewCellTypeChangeEmail: {
            HWChangeEmailController *vc = [[HWChangeEmailController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case HWSettingsFlowTableViewCellTypeChangePassword: {
            HWChangePasswordController *vc = [[HWChangePasswordController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}

@end
