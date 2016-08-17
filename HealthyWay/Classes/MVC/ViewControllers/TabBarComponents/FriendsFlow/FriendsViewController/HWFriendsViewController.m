//
//  HWFriendsViewController.m
//  HealthyWay
//
//  Created by Eugenity on 12.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWFriendsViewController.h"

@interface HWFriendsViewController ()

@end

@implementation HWFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [HWOperationsFacade fetchUsersWithFetchingType:HWFetchUsersTaskTypeTypeAll onSuccess:^(NSArray *users) {
        
    } onFailure:^(NSError *error, BOOL isCancelled) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
