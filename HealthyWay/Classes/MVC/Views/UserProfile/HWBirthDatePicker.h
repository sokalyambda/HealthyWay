//
//  HWBirthDatePicker.h
//  HealthyWay
//
//  Created by Eugenity on 10.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

@protocol HWBirthDatePickerDelegate;

@interface HWBirthDatePicker : UIView

@property (weak, nonatomic) id<HWBirthDatePickerDelegate> delegate;

@end

@protocol HWBirthDatePickerDelegate <NSObject>

@optional
- (void)birthDatePicker:(HWBirthDatePicker *)picker
          didSelectDate:(NSDate *)aDate;
- (void)birthDatePickerDidClickDoneButton:(HWBirthDatePicker *)picker;

@end