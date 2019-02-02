//
//  MKCSettingsThemeViewController.m
//  Media
//
//  Created by MarkChang on 2019/1/31.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import "MKCSettingsThemeViewController.h"
#import "MKCDataPersistence.h"

@interface MKCSettingsThemeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray<NSNumber *> *themes;

@end

@implementation MKCSettingsThemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self configureView];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.themes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *cellIdentifier = @"cellID";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
	}
	
	MKCTheme theme = (MKCTheme)indexPath.row;
	
	switch (theme) {
		case MKCThemeLight:
			cell.textLabel.text = @"淺色";
			break;
		case MKCThemeDark:
			cell.textLabel.text = @"深色";
			break;
	}
	
	if (theme == MKCDataPersistence.theme) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	MKCTheme theme = MKCDataPersistence.theme;
	
	NSIndexPath *currentSelectedIndexPath = [NSIndexPath indexPathForRow:theme inSection:0];
	[MKCDataPersistence setTheme:(MKCTheme)indexPath.row];
	[tableView reloadRowsAtIndexPaths:@[currentSelectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
	
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	cell.accessoryType = UITableViewCellAccessoryCheckmark;
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UI Layout

- (void)configureView {
	self.view.backgroundColor = [UIColor whiteColor];
	self.navigationItem.title = @"主題顏色";
	
	// table view
	[self.view addSubview:self.tableView];
	[self layoutTableView];
}

- (void)layoutTableView {
	NSArray *tableViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:nil views:@{@"tableView": self.tableView}];
	NSArray *tableViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableView]-0-|" options:0 metrics:nil views:@{@"tableView": self.tableView}];
	[self.view addConstraints:tableViewHorizontalConstraints];
	[self.view addConstraints:tableViewVerticalConstraints];
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

- (NSArray<NSNumber *> *)themes {
	if (!_themes) {
		_themes = @[@(MKCThemeLight), @(MKCThemeDark)];
	}
	return _themes;
}

@end
