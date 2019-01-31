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
#import "MKCDataPersistence.h"

@interface MKCSearchViewController () <MKCSerchViewDelegate, UITableViewDelegate, UITableViewDataSource, MKCMovieTableViewCellDelegate, MKCSongTableViewCellDelegate>

@property (nonatomic, strong) MKCSerchView *serchView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray<MKCSongInfoModel *> *songs;
@property (nonatomic, copy) NSArray<MKCMovieInfoModel *> *movies;
@property (nonatomic, strong) NSMutableSet<NSString *> *expandMovieItems;

@end

@implementation MKCSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self configureView];
	[self addObserver];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
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
	[[MKCRequestAPI sharedAPI] searchSongWithKeyword:keyword successHandler:^(NSURLResponse *response, id responseObject) {
		
		NSError *error = nil;
		MKCSongModel *model = [[MKCSongModel alloc] initWithDictionary:responseObject error:&error];
		if (error) { // Parse JSON failed
			completion(NO);
			return;
		}
		self.songs = model.results;
		completion(YES);
	} failureHandler:^(NSError *error) {
		completion(NO);
	}];
}

- (void)searchMovieWithKeyword:(NSString *)keyword completion:(void (^)(BOOL success))completion {
	[[MKCRequestAPI sharedAPI] searchMovieWithKeyword:keyword successHandler:^(NSURLResponse *response, id responseObject) {
		
		NSError *error = nil;
		MKCMovieModel *model = [[MKCMovieModel alloc] initWithDictionary:responseObject error:&error];
		if (error) { // Parse JSON failed
			completion(NO);
			return;
		}
		self.movies = model.results;
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
		return @"電影";
	} else {
		return @"音樂";
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return self.movies.count;
	} else {
		return self.songs.count;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.section == 0) {
		MKCMovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MKCMovieTableViewCell.identifier forIndexPath:indexPath];
		
		MKCMovieInfoModel *movieInfo = self.movies[indexPath.row];
		[cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:movieInfo.imageUrl]];
		cell.trackName = movieInfo.trackName;
		cell.artistName = movieInfo.artistName;
		cell.trackCensoredName = movieInfo.trackCensoredName;
		cell.trackTimeMillis = movieInfo.trackTimeMillis;
		cell.longDescription = movieInfo.longDescription;
		cell.isCollected = [MKCDataPersistence hasCollectdMovieWithTrackId:movieInfo.trackId];
		cell.isCollapsed = ![self.expandMovieItems containsObject:movieInfo.trackId];
		
		cell.delegate = self;
		cell.tag = indexPath.row;
		
		return cell;
	} else {
		MKCSongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MKCSongTableViewCell.identifier forIndexPath:indexPath];
		
		MKCSongInfoModel *songInfo = self.songs[indexPath.row];
		[cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:songInfo.imageUrl]];
		cell.trackName = songInfo.trackName;
		cell.artistName = songInfo.artistName;
		cell.collectionName = songInfo.collectionName;
		cell.trackTimeMillis = songInfo.trackTimeMillis;
		cell.isCollected = [MKCDataPersistence hasCollectdSongWithTrackId:songInfo.trackId];
		
		cell.delegate = self;
		cell.tag = indexPath.row;
		
		return cell;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSURL *openURL;
	if (indexPath.section == 0) {
		MKCMovieInfoModel *movieInfo = self.movies[indexPath.row];
		openURL = [NSURL URLWithString:movieInfo.trackViewUrl];
	} else {
		MKCSongInfoModel *movieInfo = self.songs[indexPath.row];
		openURL = [NSURL URLWithString:movieInfo.trackViewUrl];
	}
	
	[[UIApplication sharedApplication] openURL:openURL options:@{} completionHandler:nil];
}

#pragma mark - MKCSerchViewDelegate

- (void)serchView:(MKCSerchView *)serchView searchKeyword:(NSString *)keyword {
	[self searchSongAndMovieWithKeyword:keyword];
}

#pragma mark - MKCMovieTableViewCellDelegate

- (void)movieTableViewCell:(MKCMovieTableViewCell *)movieTableViewCell collectMovieAtIndex:(NSInteger)index {
	
	NSString *trackId = self.movies[index].trackId;
	
	if ([MKCDataPersistence hasCollectdMovieWithTrackId:trackId]) {
		[MKCDataPersistence removeCollectedMovieWithTrackId:trackId];
	} else {
		[MKCDataPersistence collectMovieWithTrackId:trackId];
	}
	
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
	[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)movieTableViewCell:(MKCMovieTableViewCell *)movieTableViewCell expandViewAtIndex:(NSInteger)index {
	[self.expandMovieItems addObject:self.movies[index].trackId];
	
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
	[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - MKCSongTableViewCellDelegate

- (void)songTableViewCell:(MKCSongTableViewCell *)songTableViewCell collectSongAtIndex:(NSInteger)index {
	
	NSString *trackId = self.songs[index].trackId;
	
	if ([MKCDataPersistence hasCollectdSongWithTrackId:trackId]) {
		[MKCDataPersistence removeCollectedSongWithTrackId:trackId];
	} else {
		[MKCDataPersistence collectSongWithTrackId:trackId];
	}
	
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:1];
	[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
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
		case UIStateBlank:
			[self configureInitialStateView];
			break;
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

- (void)configureInitialStateView {
	[self.activityIndicatorView stopAnimating];
	self.tableView.hidden = YES;
}

- (void)configureLoadingStateView {
	[self.activityIndicatorView startAnimating];
	self.tableView.hidden = YES;
}

- (void)configureFinishStateView {
	[self.activityIndicatorView stopAnimating];
	self.tableView.hidden = NO;
	[self.tableView reloadData];
}

- (void)configureErrorStateView {
	[self.activityIndicatorView stopAnimating];
	self.tableView.hidden = NO;
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

#pragma mark - add observer

- (void)addObserver {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableViewData:) name:MKCCollectedMovieDidChangeNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableViewData:) name:MKCCollectedSongDidChangeNotification object:nil];
}

- (void)reloadTableViewData:(NSNotification *)notification {
	[self.tableView beginUpdates];
	[self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows]
						  withRowAnimation:UITableViewRowAnimationNone];
	[self.tableView endUpdates];
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
		_tableView.hidden = YES;
		_tableView.delegate = self;
		_tableView.dataSource = self;
		_tableView.estimatedRowHeight = 200.0;
		_tableView.rowHeight = UITableViewAutomaticDimension;
	}
	return _tableView;
}

- (NSMutableSet<NSString *> *)expandMovieItems {
	if (!_expandMovieItems) {
		_expandMovieItems = [[NSMutableSet alloc] init];
	}
	return _expandMovieItems;
}

@end
