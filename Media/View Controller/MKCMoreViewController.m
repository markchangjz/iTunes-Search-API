//
//  MKCMoreViewController.m
//  Media
//
//  Created by MarkChang on 2019/1/26.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import "MKCMoreViewController.h"
#import "MKCCollectedViewController.h"
#import "NSNumber+Formatter.h"
#import "MKCDataPersistence.h"
#import "MKCWebViewController.h"
#import "MKCURLGuide.h"
#import "MKCSettingsThemeViewController.h"

@interface MKCMoreViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, readonly, strong) NSNumber *numberOfCollected;
@property (nonatomic, readonly) MKCTheme theme;

@end

@implementation MKCMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self configureView];
	[self addObserver];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - IBAction

- (void)openInfoWebView:(UIButton *)sender {
	MKCWebViewController *webViewController = [[MKCWebViewController alloc] init];
	[webViewController loadURLString:MKCURLGuide.iTunesSupport];
	
	UINavigationController *webViewNavigationController = [[UINavigationController alloc] initWithRootViewController:webViewController];
	
	[self presentViewController:webViewNavigationController animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *cellIdentifier = @"cellID";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
	}
	
	if (indexPath.section == 0) {
		cell.textLabel.text = @"主題顏色";
		
		switch (self.theme) {
			case MKCThemeLight:
				cell.detailTextLabel.text = @"淺色主題";
				break;
			case MKCThemeDark:
				cell.detailTextLabel.text = @"深色主題";
				break;
		}
	} else {
		cell.textLabel.text = @"收藏項目";
		cell.detailTextLabel.text = [NSString stringWithFormat:@"共有 %@ 項收藏", [self.numberOfCollected decimalText]];
	}
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.section == 0) {
		MKCSettingsThemeViewController *settingsThemeViewController = [[MKCSettingsThemeViewController alloc] init];
		[self.navigationController pushViewController:settingsThemeViewController animated:YES];
	} else {
		MKCCollectedViewController *collectedViewController = [[MKCCollectedViewController alloc] init];
		[self.navigationController pushViewController:collectedViewController animated:YES];
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UI Layout

- (void)configureView {
	self.view.backgroundColor = [UIColor whiteColor];
	self.navigationItem.title = @"個人資料";
	
	// table view
	[self.view addSubview:self.tableView];
	[self layoutTableView];
	
	[self configureTableFooterView];
}

- (void)configureTableFooterView {
	UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
	
	UIButton *aboutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	aboutButton.translatesAutoresizingMaskIntoConstraints = NO;
	aboutButton.frame = CGRectMake(0, 0, 0, 32);
	[aboutButton setTitle:@" 關於Apple iTunes" forState:UIControlStateNormal];
	[aboutButton setImage:[UIImage imageNamed:@"info"] forState:UIControlStateNormal];
	[aboutButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
	aboutButton.tintColor = [UIColor blackColor];
	[aboutButton addTarget:self action:@selector(openInfoWebView:) forControlEvents:UIControlEventTouchUpInside];
	
	[footerView addSubview:aboutButton];
	
	[aboutButton.trailingAnchor constraintEqualToAnchor:footerView.trailingAnchor constant:-20.0].active = YES;
	[aboutButton.centerYAnchor constraintEqualToAnchor:footerView.centerYAnchor constant:0.0].active = YES;
	
	self.tableView.tableFooterView = footerView;
}

- (void)layoutTableView {
	NSArray *tableViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:nil views:@{@"tableView": self.tableView}];
	NSArray *tableViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableView]-0-|" options:0 metrics:nil views:@{@"tableView": self.tableView}];
	[self.view addConstraints:tableViewHorizontalConstraints];
	[self.view addConstraints:tableViewVerticalConstraints];
}

#pragma mark - data source

- (NSNumber *)numberOfCollected {
	NSUInteger numberOfCollectedMovies = [MKCDataPersistence collectMovieTrackIds].count;
	NSUInteger numberOfCollectedSongs = [MKCDataPersistence collectSongTrackIds].count;
	
	return @(numberOfCollectedMovies + numberOfCollectedSongs);
}

- (MKCTheme)theme {
	return [MKCDataPersistence theme];
}

- (void)addObserver {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCollectedData:) name:MKCCollectedMovieDidChangeNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCollectedData:) name:MKCCollectedSongDidChangeNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadThemeData:) name:MKCThemeDidChangeNotification object:nil];
}

- (void)reloadCollectedData:(NSNotification *)notification {
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
	[self.tableView reloadRowsAtIndexPaths:@[indexPath]
						  withRowAnimation:UITableViewRowAnimationNone];
}

- (void)reloadThemeData:(NSNotification *)notification {
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	[self.tableView reloadRowsAtIndexPaths:@[indexPath]
						  withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - lazy instance

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
		_tableView.translatesAutoresizingMaskIntoConstraints = NO;
		_tableView.delegate = self;
		_tableView.dataSource = self;
	}
	return _tableView;
}


@end
