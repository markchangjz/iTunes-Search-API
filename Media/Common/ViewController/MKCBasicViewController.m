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
	// Tab Bar
	UITabBar *tabBar = self.tabBarController.tabBar;
	[tabBar setBarStyle:UIBarStyleDefault];
	[tabBar setUnselectedItemTintColor:[UIColor lightGrayColor]];
	[tabBar setTintColor:[UIColor blackColor]];
	
	[[UITabBar appearance] setBarStyle:UIBarStyleDefault];
	[[UITabBar appearance] setUnselectedItemTintColor:[UIColor lightGrayColor]];
	[[UITabBar appearance] setTintColor:[UIColor blackColor]];
	
	// Navigation Bar
	UINavigationBar *navigationBar = self.navigationController.navigationBar;
	[navigationBar setBarStyle:UIBarStyleDefault];
	[navigationBar setTintColor:[UIColor blackColor]];
	[navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
	
	[[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
	[[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
	[[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
	
	// Tint Color
	[UIApplication sharedApplication].delegate.window.tintColor = [UIColor darkGrayColor];
}

- (void)applyDarkTheme {
	// Tab Bar
	UITabBar *tabBar = self.tabBarController.tabBar;
	[tabBar setBarStyle:UIBarStyleBlack];
	[tabBar setUnselectedItemTintColor:[UIColor lightGrayColor]];
	[tabBar setTintColor:[UIColor whiteColor]];
	
	[[UITabBar appearance] setBarStyle:UIBarStyleBlack];
	[[UITabBar appearance] setUnselectedItemTintColor:[UIColor lightGrayColor]];
	[[UITabBar appearance] setTintColor:[UIColor whiteColor]];
	
	// Navigation Bar
	UINavigationBar *navigationBar = self.navigationController.navigationBar;
	[navigationBar setBarStyle:UIBarStyleBlack];
	[navigationBar setTintColor:[UIColor whiteColor]];
	[navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
	
	[[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
	[[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
	[[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
	
	// Tint Color
	[UIApplication sharedApplication].delegate.window.tintColor = [UIColor lightGrayColor];
}

@end
