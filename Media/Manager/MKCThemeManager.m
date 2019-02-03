//
//  MKCThemeManager.m
//  Media
//
//  Created by MarkChang on 2019/1/31.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import "MKCThemeManager.h"
#import <UIKit/UIKit.h>

@implementation MKCThemeManager

+ (MKCTheme)currentTheme {
	return [MKCDataPersistence theme];
}

+(void)applyTheme:(MKCTheme)theme {
	[MKCDataPersistence setTheme:theme];
}

+ (UIBarStyle)barStyle {
	switch (self.currentTheme) {
		case MKCThemeLight:
			return UIBarStyleDefault;
		case MKCThemeDark:
			return UIBarStyleBlack;
	}
}

@end
