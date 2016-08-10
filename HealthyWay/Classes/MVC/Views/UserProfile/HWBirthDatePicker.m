//
//  HWBirthDatePicker.m
//  HealthyWay
//
//  Created by Eugenity on 10.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWBirthDatePicker.h"

@interface HWBirthDatePicker ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation HWBirthDatePicker

#pragma mark - Actions

- (IBAction)doneClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(birthDatePickerDidClickDoneButton:)]) {
        [self.delegate birthDatePickerDidClickDoneButton:self];
    }
}

- (IBAction)birthDateChanged:(UIDatePicker *)datePicker
{
    if ([self.delegate respondsToSelector:@selector(birthDatePicker:didSelectDate:)]) {
        [self.delegate birthDatePicker:self didSelectDate:datePicker.date];
    }
}

@end
