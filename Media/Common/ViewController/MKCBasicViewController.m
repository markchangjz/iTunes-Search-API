//
//  MKCBasicViewController.m
//  Media
//
//  Created by MarkChang on 2019/1/31.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import "MKCBasicViewController.h"
#import "MKCDataPersistence.h"

/*
 Theme:
 1. https://medium.com/@mczachurski/ios-dark-theme-9a12724c112d
 2. https://medium.com/@abhimuralidharan/maintaining-a-colour-theme-manager-on-ios-swift-178b8a6a92
 */

@interface MKCBasicViewController ()

@end

@implementation MKCBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	MKCTheme theme = [MKCDataPersistence theme];
	[self applyTheme:theme];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTheme:) name:MKCThemeDidChangeNotification object:nil];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification

- (void)updateTheme:(NSNotification *)notification {
	MKCTheme theme = [MKCDataPersistence theme];
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
	UITabBar *tabBar = self.tabBarController.tabBar;
	[tabBar setBarStyle:UIBarStyleDefault];
	[tabBar setUnselectedItemTintColor:[UIColor lightGrayColor]];
	[tabBar setTintColor:[UIColor blackColor]];
	
	UINavigationBar *navigationBar = self.navigationController.navigationBar;
	[navigationBar setBarStyle:UIBarStyleDefault];
	[navigationBar setTintColor:[UIColor blackColor]];
	[navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
	
	[UIApplication sharedApplication].delegate.window.tintColor = [UIColor darkGrayColor];
}

- (void)applyDarkTheme {
	UITabBar *tabBar = self.tabBarController.tabBar;
	[tabBar setBarStyle:UIBarStyleBlack];
	[tabBar setUnselectedItemTintColor:[UIColor lightGrayColor]];
	[tabBar setTintColor:[UIColor whiteColor]];
	
	UINavigationBar *navigationBar = self.navigationController.navigationBar;
	[navigationBar setBarStyle:UIBarStyleBlack];
	[navigationBar setTintColor:[UIColor whiteColor]];
	[navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
	
	[UIApplication sharedApplication].delegate.window.tintColor = [UIColor lightGrayColor];
}

@end
