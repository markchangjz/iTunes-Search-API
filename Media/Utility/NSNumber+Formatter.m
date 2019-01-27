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
	[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
	return [formatter stringFromNumber:self];
}

@end
