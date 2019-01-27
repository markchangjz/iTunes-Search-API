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

@end

@implementation MKCCollectedMoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self configureView];
	[self lookupcollectMoviesInfo];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MKCMovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MKCMovieTableViewCell.identifier forIndexPath:indexPath];
	
	MKCMovieInfoModel *movieInfo = self.movies[indexPath.row];
	[cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:movieInfo.imageUrl]];
	cell.trackName = movieInfo.trackName;
	cell.artistName = movieInfo.artistName;
	cell.trackCensoredName = movieInfo.trackCensoredName;
	cell.trackTimeMillis = movieInfo.trackTimeMillis;
	cell.longDescription = movieInfo.longDescription;
	cell.isCollected = [MKCDataPersistence hasCollectdMovieWithTrackId:movieInfo.trackId];
	
	cell.delegate = self;
	cell.tag = indexPath.row;
	
	return cell;
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

#pragma mark - Fetch API

- (void)lookupcollectMoviesInfo {
	NSArray<NSString *> *trackIds = [MKCDataPersistence collectMovieTrackIds];
	
	if (trackIds.count == 0) {
		return;
	}
	
	[[MKCRequestAPI sharedAPI] lookupWithTrackIds:trackIds successHandler:^(NSURLResponse *response, id responseObject) {
		NSError *error = nil;
		MKCMovieModel *model = [[MKCMovieModel alloc] initWithDictionary:responseObject error:&error];
		if (error) { // Parse JSON failed
			return;
		}
		
		self.movies = model.results;
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

#pragma mark - binding

- (void)setMovies:(NSArray<MKCMovieInfoModel *> *)movies {
	_movies = movies;
	
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
