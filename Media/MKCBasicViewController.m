//
//  MKCBasicViewController.m
//  Media
//
//  Created by MarkChang on 2019/1/31.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import "MKCBasicViewController.h"
#import "MKCDataPersistence.h"

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
}

@end
