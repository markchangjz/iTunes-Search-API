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
	[self lookupcollectSongsInfo];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.songs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	MKCSongInfoModel *songInfo = self.songs[indexPath.row];
	NSURL *openURL = [NSURL URLWithString:songInfo.trackViewUrl];
	[[UIApplication sharedApplication] openURL:openURL options:@{} completionHandler:nil];
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

#pragma mark - Fetch API

- (void)lookupcollectSongsInfo {
	NSArray<NSString *> *trackIds = [MKCDataPersistence collectSongTrackIds];
	
	if (trackIds.count == 0) {
		return;
	}
	
	[[MKCRequestAPI sharedAPI] lookupWithTrackIds:trackIds successHandler:^(NSURLResponse *response, id responseObject) {
		NSError *error = nil;
		MKCSongModel *model = [[MKCSongModel alloc] initWithDictionary:responseObject error:&error];
		if (error) { // Parse JSON failed
			return;
		}
		
		self.songs = model.results;
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

#pragma mark - binding

- (void)setSongs:(NSArray<MKCSongInfoModel *> *)songs {
	_songs = songs;
	
	[self.tableView reloadData];
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
