//
//  HWCommonDateFormatter.m
//  HealthyWay
//
//  Created by Eugenity on 10.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWCommonDateFormatter.h"

@implementation HWCommonDateFormatter

#pragma mark - Lifecycle

+ (NSDateFormatter *)commonDateFormatter
{
    static NSDateFormatter *dateFormatter = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    });
    
    return dateFormatter;
}

@end
