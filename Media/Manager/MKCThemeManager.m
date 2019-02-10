//
//  MKCThemeManager.m
//  Media
//
//  Created by MarkChang on 2019/1/31.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import "MKCThemeManager.h"

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

+ (UIColor *)tabBarUnselectedItemTintColor {
	switch (self.currentTheme) {
		case MKCThemeLight:
			return [UIColor lightGrayColor];
		case MKCThemeDark:
			return [UIColor lightGrayColor];
	}
}

+ (UIColor *)tabBarTintColor {
	switch (self.currentTheme) {
		case MKCThemeLight:
			return [UIColor blackColor];
		case MKCThemeDark:
			return [UIColor whiteColor];
	}
}

+ (UIColor *)navigationBarTintColor {
	switch (self.currentTheme) {
		case MKCThemeLight:
			return [UIColor blackColor];
		case MKCThemeDark:
			return [UIColor whiteColor];
	}
}

+ (UIColor *)navigationTitleColor {
	switch (self.currentTheme) {
		case MKCThemeLight:
			return [UIColor blackColor];
		case MKCThemeDark:
			return [UIColor whiteColor];
	}
}

+ (UIColor *)tintColor {
	switch (self.currentTheme) {
		case MKCThemeLight:
			return [UIColor darkGrayColor];
		case MKCThemeDark:
			return [UIColor lightGrayColor];
	}
}

@end
