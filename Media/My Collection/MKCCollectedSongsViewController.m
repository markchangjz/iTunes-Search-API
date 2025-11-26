//
//  MKCCollectedSongsViewController.m
//  Media
//
//  Created by MarkChang on 2019/1/27.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import "MKCCollectedSongsViewController.h"
#import "MKCRequestAPI.h"
#import "MKCDataPersistence.h"
#import "MKCJSONModel.h"
#import "MKCSongTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface MKCCollectedSongsViewController () <UITableViewDelegate, UITableViewDataSource, MKCSongTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray<MKCSongInfoModel *> *songs;

@end

@implementation MKCCollectedSongsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self configureView];
	[self lookupCollectSongsInfo];
	[self addObserver];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.songs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MKCSongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MKCSongTableViewCell.identifier forIndexPath:indexPath];
	
	MKCSongInfoModel *songInfo = self.songs[indexPath.row];
	// 優化圖片載入：使用 SDWebImage 的緩存策略和錯誤處理
	[cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:songInfo.imageUrl]
							placeholderImage:nil
									 options:SDWebImageRetryFailed | SDWebImageHighPriority
								   completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
		if (error) {
			cell.coverImageView.backgroundColor = [UIColor lightGrayColor];
		}
	}];
	cell.trackName = songInfo.trackName;
	cell.artistName = songInfo.artistName;
	cell.collectionName = songInfo.collectionName;
	cell.duration = songInfo.trackTime;
	// 由於此頁面只顯示已收藏的項目，直接設為 YES，避免重複查詢
	cell.isCollected = YES;
	
	cell.delegate = self;
	cell.tag = indexPath.row;
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	MKCSongInfoModel *songInfo = self.songs[indexPath.row];
	NSURL *openURL = [NSURL URLWithString:songInfo.trackViewUrl];
	[[UIApplication sharedApplication] openURL:openURL options:@{} completionHandler:nil];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - MKCSongTableViewCellDelegate

- (void)songTableViewCell:(MKCSongTableViewCell *)songTableViewCell collectSongAtIndex:(NSInteger)index {
	
	NSIndexPath *deleteIndexPath = [self.tableView indexPathForCell:songTableViewCell];
	NSInteger deleteIndex = deleteIndexPath.row;
	
	NSString *trackId = self.songs[deleteIndex].trackId;
	
	if ([MKCDataPersistence hasCollectdSongWithTrackId:trackId]) {
		[MKCDataPersistence removeCollectedSongWithTrackId:trackId];
		
		NSMutableArray *songs = [self.songs mutableCopy];
		[songs removeObjectAtIndex:deleteIndex];
		self.songs = songs;
		
		[self.tableView deleteRowsAtIndexPaths:@[deleteIndexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
}

#pragma mark - Fetch API

- (void)lookupCollectSongsInfo {
	NSArray<NSString *> *trackIds = [MKCDataPersistence collectSongTrackIds];
	
	if (trackIds.count == 0) {
		self.songs = @[];
		[self.tableView reloadData];
		return;
	}
	
	[[MKCRequestAPI sharedAPI] lookupWithTrackIds:trackIds successHandler:^(NSURLResponse *response, id responseObject) {
		NSError *error = nil;
		MKCSongModel *model = [[MKCSongModel alloc] initWithDictionary:responseObject error:&error];
		if (error) { // Parse JSON failed
			return;
		}
		
		self.songs = model.results;
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
	
	[self.tableView registerClass:[MKCSongTableViewCell class] forCellReuseIdentifier:MKCSongTableViewCell.identifier];
}

- (void)layoutTableView {
	NSArray *tableViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:nil views:@{@"tableView": self.tableView}];
	NSArray *tableViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableView]-0-|" options:0 metrics:nil views:@{@"tableView": self.tableView}];
	[self.view addConstraints:tableViewHorizontalConstraints];
	[self.view addConstraints:tableViewVerticalConstraints];
}

#pragma mark - add observer

- (void)addObserver {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableViewData:) name:MKCCollectedSongDidChangeNotification object:nil];
}

- (void)reloadTableViewData:(NSNotification *)notification {
	
	if (self.tabBarController.selectedIndex == 1) {
		return;
	}
	
	[self lookupCollectSongsInfo];
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

@end
