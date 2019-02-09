//
//  NSNumber+Formatter.m
//  Media
//
//  Created by MarkChang on 2019/1/27.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import "NSNumber+Formatter.h"

@implementation NSNumber (Formatter)

- (NSString *)decimalText {	
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	formatter.numberStyle = NSNumberFormatterDecimalStyle;
	return [formatter stringFromNumber:self];
}

- (NSString *)durationText {
	// Reference: https://crunchybagel.com/formatting-a-duration-with-nsdatecomponentsformatter/
	
	NSTimeInterval duration = self.doubleValue;
	NSDateComponentsFormatter *formatter = [[NSDateComponentsFormatter alloc] init];
	formatter.unitsStyle = NSDateComponentsFormatterUnitsStylePositional;
	formatter.allowedUnits = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
	formatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorDefault;
	return [formatter stringFromTimeInterval:duration];
}

@end
