//
//  MKCBasicViewController.m
//  Media
//
//  Created by MarkChang on 2019/1/31.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import "MKCBasicViewController.h"
#import "MKCDataPersistence.h"
#import "MKCThemeManager.h"

/*
 Theme:
 1. https://medium.com/@mczachurski/ios-dark-theme-9a12724c112d
 2. https://medium.com/@abhimuralidharan/maintaining-a-colour-theme-manager-on-ios-swift-178b8a6a92
 */

@interface MKCBasicViewController ()

@end

@implementation MKCBasicViewController

- (instancetype)init {
	self = [super init];
	if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTheme:) name:MKCThemeDidChangeNotification object:nil];
	}
	return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification

- (void)updateTheme:(NSNotification *)notification {
	MKCTheme theme = MKCThemeManager.currentTheme;
	[self applyTheme:theme];
}

#pragma mark - functions

- (void)applyTheme:(MKCTheme)theme {
	switch (theme) {
		case MKCThemeLight:
			[self applyLightTheme];
			break;
		case MKCThemeDark:
			[self applyDarkTheme];
			break;
	}
}

- (void)applyLightTheme {
	[self setTintColor];
	[self setTabBarAppearance];
	[self setNavigationBarAppearance];
}

- (void)applyDarkTheme {
	[self setTintColor];
	[self setTabBarAppearance];
	[self setNavigationBarAppearance];
}

- (void)setTintColor {
	[UIApplication sharedApplication].delegate.window.tintColor = MKCThemeManager.tintColor;
}

- (void)setTabBarAppearance {
	NSArray *tabBars = @[self.tabBarController.tabBar,
						 UITabBar.appearance
						 ];
	
	for (UITabBar *tabBar in tabBars) {
		tabBar.barStyle = MKCThemeManager.barStyle;
		tabBar.unselectedItemTintColor = MKCThemeManager.tabBarUnselectedItemTintColor;
		tabBar.tintColor = MKCThemeManager.tabBarTintColor;
	}
}

- (void)setNavigationBarAppearance {
	NSArray *navigationBars = @[self.navigationController.navigationBar,
								UINavigationBar.appearance
								];
	
	for (UINavigationBar *navigationBar in navigationBars) {
		navigationBar.barStyle = MKCThemeManager.barStyle;
		navigationBar.tintColor = MKCThemeManager.navigationBarTintColor;
		navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: MKCThemeManager.navigationTitleColor};
	}
}

@end
