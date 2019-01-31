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

+(void)applyTheme:(MKCTheme)theme {
	switch (theme) {
		case MKCThemeLight:
			[self applyLightTheme];
			break;
		case MKCThemeDark:
			[self applyDarkTheme];
			break;
	}
}

+ (void)applyLightTheme {
	[[UITabBar appearance] setBarStyle:UIBarStyleDefault];
	[[UITabBar appearance] setUnselectedItemTintColor:[UIColor lightGrayColor]];
	[[UITabBar appearance] setTintColor:[UIColor blackColor]];
	
	[[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
	[[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
	[[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
}

+ (void)applyDarkTheme {
	[[UITabBar appearance] setBarStyle:UIBarStyleBlack];
	[[UITabBar appearance] setUnselectedItemTintColor:[UIColor lightGrayColor]];
	[[UITabBar appearance] setTintColor:[UIColor whiteColor]];
	
	[[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
	[[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
	[[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

@end
