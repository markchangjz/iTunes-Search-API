//
//  MKCCollectedViewController.m
//  Media
//
//  Created by MarkChang on 2019/1/27.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import "MKCCollectedViewController.h"
#import "MKCCollectedMoviesViewController.h"
#import "MKCCollectedSongsViewController.h"
#import "YSLContainerViewController.h"

@interface MKCCollectedViewController ()

@end

@implementation MKCCollectedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self configureView];
}

#pragma mark - UI Layout

- (void)configureView {
	self.view.backgroundColor = [UIColor whiteColor];
	
	MKCCollectedMoviesViewController *collectedMoviesViewController = [[MKCCollectedMoviesViewController alloc] init];
	collectedMoviesViewController.title = @"電影";
	
	MKCCollectedSongsViewController *collectedSongsViewController = [[MKCCollectedSongsViewController alloc] init];
	collectedSongsViewController.title = @"音樂";
	
	float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
	float navigationHeight = self.navigationController.navigationBar.frame.size.height;
	
	NSArray<UIViewController *> *controllers = @[collectedMoviesViewController, collectedSongsViewController];
	
	YSLContainerViewController *containerViewController = [[YSLContainerViewController alloc] initWithControllers:controllers topBarHeight:statusHeight + navigationHeight parentViewController:self];
	
	[self.view addSubview:containerViewController.view];
}

@end
