//
//  HWBaseFriendCellConfigurationStrategy.h
//  HealthyWay
//
//  Created by Eugenity on 24.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWFriendCellConfigurationStrategy.h"

@interface HWBaseFriendCellConfigurationStrategy : NSObject<HWFriendCellConfigurationStrategy>

@property (weak, nonatomic) UITableViewCell *friendCell;

@end
