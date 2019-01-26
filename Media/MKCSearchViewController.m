//
//  MKCSearchViewController.m
//  Media
//
//  Created by MarkChang on 2019/1/26.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import "MKCSearchViewController.h"
#import "MKCRequestAPI.h"
#import "MKCJSONModel.h"
#import "MKCSerchView.h"
#import "MKCSongTableViewCell.h"
#import "MKCMovieTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface MKCSearchViewController () <MKCSerchViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) MKCSerchView *serchView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray<MKCSongInfoModel *> *songs;
@property (nonatomic, copy) NSArray<MKCMovieInfoModel *> *movies;

@end

@implementation MKCSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self configureView];
}

#pragma mark - Fetch API

- (void)searchSongAndMovieWithKeyword:(NSString *)keyword {
	self.state = UIStateLoading;
	
	dispatch_group_t group = dispatch_group_create();
	dispatch_queue_global_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	
	dispatch_group_async(group, concurrentQueue, ^{
		dispatch_group_enter(group);
		[self searchSongWithKeyword:keyword completion:^(BOOL success) {
			dispatch_group_leave(group);
		}];
	});
	
	dispatch_group_async(group, concurrentQueue, ^{
		dispatch_group_enter(group);
		[self searchMovieWithKeyword:keyword completion:^(BOOL success) {
			dispatch_group_leave(group);
		}];
	});
	
	dispatch_group_notify(group, dispatch_get_main_queue(), ^{
		self.state = UIStateFinish;
	});
}

- (void)searchSongWithKeyword:(NSString *)keyword completion:(void (^)(BOOL success))completion {
	[[MKCRequestAPI sharedAPI] fetchSongWithKeyword:keyword successHandler:^(NSURLResponse *response, id responseObject) {
		
		NSError *error = nil;
		MKCSongModel *model = [[MKCSongModel alloc] initWithDictionary:responseObject error:&error];
		if (error) { // Parse JSON failed
			completion(NO);
			return;
		}
		self.songs = model.results;
		NSLog(@"song: %@", model.resultCount);
		completion(YES);
	} failureHandler:^(NSError *error) {
		completion(NO);
	}];
}

- (void)searchMovieWithKeyword:(NSString *)keyword completion:(void (^)(BOOL success))completion {
	[[MKCRequestAPI sharedAPI] fetchMovieWithKeyword:keyword successHandler:^(NSURLResponse *response, id responseObject) {
		
		NSError *error = nil;
		MKCMovieModel *model = [[MKCMovieModel alloc] initWithDictionary:responseObject error:&error];
		if (error) { // Parse JSON failed
			completion(NO);
			return;
		}
		self.movies = model.results;
		NSLog(@"movie: %@", model.resultCount);
		completion(YES);
	} failureHandler:^(NSError *error) {
		completion(NO);
	}];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return @"音樂";
	} else {
		return @"電影";
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return self.songs.count;
	} else {
		return self.movies.count;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.section == 0) {
		MKCSongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MKCSongTableViewCell.identifier forIndexPath:indexPath];
		
		MKCSongInfoModel *songInfo = self.songs[indexPath.row];
		
		[cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:songInfo.imageUrl]];
		cell.trackName = songInfo.trackName;
		cell.artistName = songInfo.artistName;
		cell.collectionName = songInfo.collectionName;
		cell.trackTimeMillis = songInfo.trackTimeMillis;
		
		return cell;
	} else {
		MKCMovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MKCMovieTableViewCell.identifier forIndexPath:indexPath];
		cell.textLabel.text = self.movies[indexPath.row].trackName;
		[cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:self.movies[indexPath.row].imageUrl]];
		return cell;
	}
}

#pragma mark - MKCSerchViewDelegate

- (void)serchView:(MKCSerchView *)serchView searchKeyword:(NSString *)keyword {
	[self searchSongAndMovieWithKeyword:keyword];
}

#pragma mark - UI State

- (void)setState:(UIState)state {
	_state = state;
	
	dispatch_async(dispatch_get_main_queue(), ^{
		[self configureStateView];
	});
}

- (void)configureStateView {
	switch (self.state) {
		case UIStateLoading:
			[self configureLoadingStateView];
			break;
		case UIStateFinish:
			[self configureFinishStateView];
			break;
		case UIStateError:
			[self configureErrorStateView];
			break;
	}
}

- (void)configureLoadingStateView {
	[self.activityIndicatorView startAnimating];
	self.tableView.alpha = 0.0;
}

- (void)configureFinishStateView {
	[self.activityIndicatorView stopAnimating];
	self.tableView.alpha = 1.0;
	[self.tableView reloadData];
}

- (void)configureErrorStateView {
	[self.activityIndicatorView stopAnimating];
	self.tableView.alpha = 1.0;
}

#pragma mark - UI Layout

- (void)configureView {
	self.view.backgroundColor = [UIColor whiteColor];
	self.navigationItem.titleView = self.serchView;
	
	// loading view
	[self.view addSubview:self.activityIndicatorView];
	[self layoutActivityIndicatorView];
	
	// table view
	[self.view addSubview:self.tableView];
	[self layoutTableView];
	
	[self.tableView registerClass:[MKCSongTableViewCell class] forCellReuseIdentifier:MKCSongTableViewCell.identifier];
	[self.tableView registerClass:[MKCMovieTableViewCell class] forCellReuseIdentifier:MKCMovieTableViewCell.identifier];
}

- (void)layoutActivityIndicatorView {
	[self.activityIndicatorView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
	[self.activityIndicatorView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
}

- (void)layoutTableView {
	NSArray *tableViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:nil views:@{@"tableView": self.tableView}];
	NSArray *tableViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableView]-0-|" options:0 metrics:nil views:@{@"tableView": self.tableView}];
	[self.view addConstraints:tableViewHorizontalConstraints];
	[self.view addConstraints:tableViewVerticalConstraints];
}

#pragma mark - lazy instance

- (MKCSerchView *)serchView {
	if (!_serchView) {
		_serchView = [[MKCSerchView alloc] init];
		_serchView.delegate = self;
	}
	return _serchView;
}

- (UIActivityIndicatorView *)activityIndicatorView {
	if (!_activityIndicatorView) {
		_activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		_activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
	}
	return _activityIndicatorView;
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] init];
		_tableView.translatesAutoresizingMaskIntoConstraints = NO;
		_tableView.delegate = self;
		_tableView.dataSource = self;
		_tableView.estimatedRowHeight = 200.0;
		_tableView.rowHeight = UITableViewAutomaticDimension;
	}
	return _tableView;
}

@end
