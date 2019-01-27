//
//  MKCMainTabBarController.m
//  Media
//
//  Created by MarkChang on 2019/1/26.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import "MKCMainTabBarController.h"
#import "MKCSearchViewController.h"
#import "MKCMoreViewController.h"

@interface MKCMainTabBarController ()

@end

@implementation MKCMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	MKCSearchViewController *searchViewController = [[MKCSearchViewController alloc] init];
	searchViewController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:0];
	UINavigationController *searchNavigationController = [[UINavigationController alloc] initWithRootViewController:searchViewController];
	
	MKCMoreViewController *moreViewController = [[MKCMoreViewController alloc] init];
	moreViewController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:1];
	UINavigationController *moreNavigationController = [[UINavigationController alloc] initWithRootViewController:moreViewController];
	
	self.viewControllers = @[searchNavigationController, moreNavigationController];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
