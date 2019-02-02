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
#import "MKCSongTableViewCell.h"
#import "MKCMovieTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MKCDataPersistence.h"
#import "MKCMovieCellModel.h"
#import "MKCSongCellModel.h"

@interface MKCSearchViewController () <UITableViewDelegate, UITableViewDataSource, MKCMovieTableViewCellDelegate, MKCSongTableViewCellDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray<MKCSongInfoModel *> *songs;
@property (nonatomic, copy) NSArray<MKCMovieInfoModel *> *movies;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSArray<JSONModel *> *> *mediaElements;
@property (nonatomic, strong) NSArray<NSNumber *> *cellList;
@property (nonatomic, strong) NSMutableSet<NSString *> *expandMovieItems;

@end

@implementation MKCSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.cellList = @[@(MKCMediaTypeMovie), @(MKCMediaTypeSong)];
	
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
		self.mediaElements = [NSMutableDictionary new];//[[NSMutableArray alloc] initWithCapacity:2];
		
//		MKCMediaType type = (MKCMediaType)self.cellList[indexPath.section].integerValue;
		
		[self.cellList enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			MKCMediaType type = obj.integerValue;
			
			switch (type) {
				case MKCMediaTypeMovie:
					self.mediaElements[@(type)] = self.movies;
					break;
				case MKCMediaTypeSong:
					self.mediaElements[@(type)] = self.songs;
					break;
			}
		}];
		
//		[self.mediaElements insertObject:self.movies atIndex:0];
//		[self.mediaElements insertObject:self.songs atIndex:1];
//
		
//		for (MKCMovieInfoModel *movie in self.movies) {
//			MKCMovieCellModel *model = [[MKCMovieCellModel alloc] init];
//			model.mediaInfo = movie;
//			model.type = MKCMediaTypeMovie;
//			[self.mediaElements addObject:model];
//		}
//
//		for (MKCSongInfoModel *song in self.songs) {
//			MKCMediaCellModel *model = [[MKCMediaCellModel alloc] init];
//			model.mediaInfo = song;
//			model.type = MKCMediaTypeSong;
//			[self.mediaElements addObject:model];
//		}
		
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

#pragma mark - configure UI data

- (MKCMovieTableViewCell *)setupMovieTableViewCellWithCell:(MKCBasicMediaTableViewCell *)cell cellModel:(MKCMovieInfoModel *)cellModel {
	MKCMovieTableViewCell *movieCell = (MKCMovieTableViewCell *)cell;
	movieCell.delegate = self;
	movieCell.isCollected = [MKCDataPersistence hasCollectdMovieWithTrackId:cellModel.trackId];
	movieCell.isCollapsed = ![self.expandMovieItems containsObject:cellModel.trackId];
	return movieCell;
}

- (MKCSongTableViewCell *)setupSongTableViewCellWithCell:(MKCBasicMediaTableViewCell *)cell cellModel:(MKCSongInfoModel *)cellModel {
	MKCSongTableViewCell *songCell = (MKCSongTableViewCell *)cell;
	songCell.delegate = self;
	songCell.isCollected = [MKCDataPersistence hasCollectdSongWithTrackId:cellModel.trackId];
	return songCell;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//	return 2;
	return self.cellList.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//	if (section == 0) {
//		return @"電影";
//	} else {
//		return @"音樂";
//	}
	
	MKCMediaType type = (MKCMediaType)self.cellList[section].integerValue;
	
	switch (type) {
		case MKCMediaTypeMovie:
			return @"電影";
		case MKCMediaTypeSong:
			return @"音樂";
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//	if (section == 0) {
//		return self.movies.count;
//	} else {
//		return self.songs.count;
//	}
	
	MKCMediaType type = (MKCMediaType)self.cellList[section].integerValue;
	
	return self.mediaElements[@(type)].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	/*
	 let cellModel = customElements[indexPath.row]
	 let cellIdentifier = cellModel.tpye.rawValue
	 let customCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomElementCell
	 
	 customCell.configure(withModel: cellModel)
	 
	 return customCell as! UITableViewCell
	 */
	
	MKCMediaType type = (MKCMediaType)self.cellList[indexPath.section].integerValue;
	
	JSONModel *cellModel = self.mediaElements[@(type)][indexPath.row];
	
	NSString *cellIdentifier = [NSString stringWithFormat:@"%ld", type];
	MKCBasicMediaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
	
	[cell configureWithModel2:cellModel];
	
	switch (type) {
		case MKCMediaTypeMovie:
			cell = [self setupMovieTableViewCellWithCell:cell cellModel:(MKCMovieInfoModel *)cellModel];
			break;
		case MKCMediaTypeSong:
			cell = [self setupSongTableViewCellWithCell:cell cellModel:(MKCSongInfoModel *)cellModel];
			break;
	}
	
	cell.tag = indexPath.row;
	
	return cell;
	
	if (indexPath.section == 0) {
		MKCMovieTableViewCell *movieCell = (MKCMovieTableViewCell *)cell;
		movieCell.delegate = self;
		MKCMovieInfoModel *model = (MKCMovieInfoModel *)cellModel;
		movieCell.isCollected = [MKCDataPersistence hasCollectdMovieWithTrackId:model.trackId];
		movieCell.isCollapsed = ![self.expandMovieItems containsObject:model.trackId];
		cell = movieCell;
	} else {
		[(MKCSongTableViewCell *)cell setDelegate:self];
		MKCSongInfoModel *model = (MKCSongInfoModel *)cellModel;
		cell.isCollected = [MKCDataPersistence hasCollectdSongWithTrackId:model.trackId];
	}
	
	cell.tag = indexPath.row;
	return cell;

	
	if (indexPath.section == 0) {
		MKCMovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MKCMovieTableViewCell.identifier forIndexPath:indexPath];
		
		MKCMovieCellModel *movieModel = [MKCMovieCellModel new];
		movieModel.mediaInfo = self.movies[indexPath.row];
		[cell configureWithModel:movieModel];
		
		MKCMovieInfoModel *movieInfo = self.movies[indexPath.row];
		[cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:movieInfo.imageUrl]];
//		cell.trackName = movieInfo.trackName;
//		cell.artistName = movieInfo.artistName;
//		cell.trackCensoredName = movieInfo.trackCensoredName;
//		cell.trackTimeMillis = movieInfo.trackTimeMillis;
//		cell.longDescription = movieInfo.longDescription;
		cell.isCollected = [MKCDataPersistence hasCollectdMovieWithTrackId:movieInfo.trackId];
		cell.isCollapsed = ![self.expandMovieItems containsObject:movieInfo.trackId];
		
		cell.delegate = self;
		cell.tag = indexPath.row;
		
		return cell;
	} else {
		MKCSongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MKCSongTableViewCell.identifier forIndexPath:indexPath];
		
		MKCSongCellModel *songModel = [MKCSongCellModel new];
		songModel.mediaInfo = self.songs[indexPath.row];
		[cell configureWithModel:songModel];
		
		MKCSongInfoModel *songInfo = self.songs[indexPath.row];
		[cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:songInfo.imageUrl]];
//		cell.trackName = songInfo.trackName;
//		cell.artistName = songInfo.artistName;
//		cell.collectionName = songInfo.collectionName;
//		cell.trackTimeMillis = songInfo.trackTimeMillis;
		cell.isCollected = [MKCDataPersistence hasCollectdSongWithTrackId:songInfo.trackId];
		
		cell.delegate = self;
		cell.tag = indexPath.row;
		
		return cell;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	MKCMediaType type = (MKCMediaType)self.cellList[indexPath.section].integerValue;
	JSONModel *mediaInfoModel = self.mediaElements[@(type)][indexPath.row];
	
	NSURL *openURL;
	
	switch (type) {
		case MKCMediaTypeMovie:
		{
			MKCMovieInfoModel *movieInfo = (MKCMovieInfoModel *)mediaInfoModel;
			openURL = [NSURL URLWithString:movieInfo.trackViewUrl];
		}
			break;
			
		case MKCMediaTypeSong:
		{
			MKCSongInfoModel *songInfo = (MKCSongInfoModel *)mediaInfoModel;
			openURL = [NSURL URLWithString:songInfo.trackViewUrl];
		}
			break;
	}
	
	[[UIApplication sharedApplication] openURL:openURL options:@{} completionHandler:nil];
	
//	NSURL *openURL;
//	if (indexPath.section == 0) {
//		MKCMovieInfoModel *movieInfo = self.movies[indexPath.row];
//		openURL = [NSURL URLWithString:movieInfo.trackViewUrl];
//	} else {
//		MKCSongInfoModel *movieInfo = self.songs[indexPath.row];
//		openURL = [NSURL URLWithString:movieInfo.trackViewUrl];
//	}
//
//	[[UIApplication sharedApplication] openURL:openURL options:@{} completionHandler:nil];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	[searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
	[searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];
	
	[self searchSongAndMovieWithKeyword:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];
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
	self.navigationItem.titleView = self.searchBar;
	
	// loading view
	[self.view addSubview:self.activityIndicatorView];
	[self layoutActivityIndicatorView];
	
	// table view
	[self.view addSubview:self.tableView];
	[self layoutTableView];
	
	[self.cellList enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		MKCMediaType type = obj.integerValue;
		NSString *cellIdentifier = [NSString stringWithFormat:@"%ld", type];
		Class cellClass;
		
		switch (type) {
			case MKCMediaTypeMovie:
				cellClass = [MKCMovieTableViewCell class];
				break;
			case MKCMediaTypeSong:
				cellClass = [MKCSongTableViewCell class];
				break;
		}
		
		[self.tableView registerClass:cellClass forCellReuseIdentifier:cellIdentifier];
	}];
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

- (UISearchBar *)searchBar {
	if (!_searchBar) {
		_searchBar = [[UISearchBar alloc] init];
		_searchBar.delegate = self;
		_searchBar.placeholder = @"搜尋";
	}
	return _searchBar;
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
