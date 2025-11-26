//
//  MKCCollectedMoviesViewController.m
//  Media
//
//  Created by MarkChang on 2019/1/27.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import "MKCCollectedMoviesViewController.h"
#import "MKCRequestAPI.h"
#import "MKCDataPersistence.h"
#import "MKCJSONModel.h"
#import "MKCMovieTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface MKCCollectedMoviesViewController () <UITableViewDelegate, UITableViewDataSource, MKCMovieTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray<MKCMovieInfoModel *> *movies;
@property (nonatomic, strong) NSMutableSet<NSString *> *expandMovieItems;

@end

@implementation MKCCollectedMoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self configureView];
	[self lookupCollectMoviesInfo];
	[self addObserver];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MKCMovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MKCMovieTableViewCell.identifier forIndexPath:indexPath];
	
	MKCMovieInfoModel *movieInfo = self.movies[indexPath.row];
	// 優化圖片載入：使用 SDWebImage 的緩存策略和錯誤處理
	[cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:movieInfo.imageUrl]
							placeholderImage:nil
									 options:SDWebImageRetryFailed | SDWebImageHighPriority
								   completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
		if (error) {
			cell.coverImageView.backgroundColor = [UIColor lightGrayColor];
		}
	}];
	cell.trackName = movieInfo.trackName;
	cell.artistName = movieInfo.artistName;
	cell.trackCensoredName = movieInfo.trackCensoredName;
	cell.duration = movieInfo.trackTime;
	cell.longDescription = movieInfo.longDescription;
	// 由於此頁面只顯示已收藏的項目，直接設為 YES，避免重複查詢
	cell.isCollected = YES;
	cell.isCollapsed = ![self.expandMovieItems containsObject:movieInfo.trackId];
	
	cell.delegate = self;
	cell.tag = indexPath.row;
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	MKCMovieInfoModel *movieInfo = self.movies[indexPath.row];
	NSURL *openURL = [NSURL URLWithString:movieInfo.trackViewUrl];
	[[UIApplication sharedApplication] openURL:openURL options:@{} completionHandler:nil];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - MKCMovieTableViewCellDelegate

- (void)movieTableViewCell:(MKCMovieTableViewCell *)movieTableViewCell collectMovieAtIndex:(NSInteger)index {
	
	NSIndexPath *deleteIndexPath = [self.tableView indexPathForCell:movieTableViewCell];
	NSInteger deleteIndex = deleteIndexPath.row;
	
	NSString *trackId = self.movies[deleteIndex].trackId;
	
	if ([MKCDataPersistence hasCollectdMovieWithTrackId:trackId]) {
		[MKCDataPersistence removeCollectedMovieWithTrackId:trackId];
		
		NSMutableArray *movies = [self.movies mutableCopy];
		[movies removeObjectAtIndex:deleteIndex];
		self.movies = movies;
		
		[self.tableView deleteRowsAtIndexPaths:@[deleteIndexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
}

- (void)movieTableViewCell:(MKCMovieTableViewCell *)movieTableViewCell expandViewAtIndex:(NSInteger)index {
	
	NSIndexPath *selectedIndexPath = [self.tableView indexPathForCell:movieTableViewCell];
	NSInteger selectedIndex = selectedIndexPath.row;
	
	[self.expandMovieItems addObject:self.movies[selectedIndex].trackId];
	
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
	[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Fetch API

- (void)lookupCollectMoviesInfo {
	NSArray<NSString *> *trackIds = [MKCDataPersistence collectMovieTrackIds];
	
	if (trackIds.count == 0) {
		self.movies = @[];
		[self.tableView reloadData];
		return;
	}
	
	[[MKCRequestAPI sharedAPI] lookupWithTrackIds:trackIds successHandler:^(NSURLResponse *response, id responseObject) {
		NSError *error = nil;
		MKCMovieModel *model = [[MKCMovieModel alloc] initWithDictionary:responseObject error:&error];
		if (error) { // Parse JSON failed
			return;
		}
		
		self.movies = model.results;
		[self.tableView reloadData];
	} failureHandler:^(NSError *error) {
		
	}];
}

#pragma mark - UI Layout

- (void)configureView {
	self.view.backgroundColor = [UIColor whiteColor];
	
	// table view
	[self.view addSubview:self.tableView];
	[self layoutTableView];
	
	[self.tableView registerClass:[MKCMovieTableViewCell class] forCellReuseIdentifier:MKCMovieTableViewCell.identifier];
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
}

- (void)reloadTableViewData:(NSNotification *)notification {
	
	if (self.tabBarController.selectedIndex == 1) {
		return;
	}
	
	[self lookupCollectMoviesInfo];
}

#pragma mark - lazy instance

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

- (NSMutableSet<NSString *> *)expandMovieItems {
	if (!_expandMovieItems) {
		_expandMovieItems = [[NSMutableSet alloc] init];
	}
	return _expandMovieItems;
}

@end
