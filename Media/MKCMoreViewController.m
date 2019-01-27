//
//  MKCMoreViewController.m
//  Media
//
//  Created by MarkChang on 2019/1/26.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import "MKCMoreViewController.h"

@interface MKCMoreViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MKCMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self configureView];
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
		cell.detailTextLabel.text = @"淺色主題";
	} else {
		cell.textLabel.text = @"收藏項目";
		cell.detailTextLabel.text = @"共有 # 項收藏";
	}
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.section == 0) {
		
	} else {
		
	}
}

#pragma mark - UI Layout

- (void)configureView {
	self.view.backgroundColor = [UIColor whiteColor];
	self.navigationItem.title = @"個人資料";
	
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


@end
