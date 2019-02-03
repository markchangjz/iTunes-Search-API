//
//  MKCSongTableViewCell.m
//  Media
//
//  Created by MarkChang on 2019/1/26.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import "MKCSongTableViewCell.h"
#import "MKCSongModel.h"
#import "UIImageView+WebCache.h"
#import "NSNumber+Formatter.h"

@interface MKCSongTableViewCell()

@property (nonatomic, copy) UILabel *trackNameLabel;
@property (nonatomic, copy) UILabel *artistNameLabel;
@property (nonatomic, copy) UILabel *collectionNameLabel;
@property (nonatomic, copy) UILabel *trackTimeMillisLabel;

@end

@implementation MKCSongTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		[self configureContentStackView];
		[self.collectionButton addTarget:self action:@selector(collect:) forControlEvents:UIControlEventTouchUpInside];
	}
	return self;
}

#pragma mark - IBAction

- (void)collect:(UIButton *)sender {
	if (self.delegate) {
		[self.delegate songTableViewCell:self collectSongAtIndex:self.tag];
	}
}

#pragma mark - Override

- (void)configureWithModel:(JSONModel *)model {
	MKCSongInfoModel *song = (MKCSongInfoModel *)model;
	[self.coverImageView sd_setImageWithURL:[NSURL URLWithString:song.imageUrl]];
	self.trackName = song.trackName;
	self.artistName = song.artistName;
	self.collectionName = song.collectionName;
	self.trackTimeMillis = [song.trackTime durationText];
}

#pragma mark - UI layout

- (void)configureContentStackView {
	[self.contentStackView addArrangedSubview:self.trackNameLabel];
	[self.contentStackView addArrangedSubview:self.artistNameLabel];
	[self.contentStackView addArrangedSubview:self.collectionNameLabel];
	[self.contentStackView addArrangedSubview:self.trackTimeMillisLabel];
}

#pragma mark - binding

- (void)setTrackName:(NSString *)trackName {
	_trackName = trackName;
	self.trackNameLabel.text = trackName;
}

- (void)setArtistName:(NSString *)artistName {
	_artistName = artistName;
	self.artistNameLabel.text = artistName;
}

- (void)setCollectionName:(NSString *)collectionName {
	_collectionName = collectionName;
	self.collectionNameLabel.text = collectionName;
}

- (void)setTrackTimeMillis:(NSString *)trackTimeMillis {
	_trackTimeMillis = trackTimeMillis;
	self.trackTimeMillisLabel.text = trackTimeMillis;
}

#pragma mark - lazy instance

- (UILabel *)trackNameLabel {
	if (!_trackNameLabel) {
		_trackNameLabel = [[UILabel alloc] init];
		_trackNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
		_trackNameLabel.font = [UIFont boldSystemFontOfSize:18.0];
	}
	return _trackNameLabel;
}

- (UILabel *)artistNameLabel {
	if (!_artistNameLabel) {
		_artistNameLabel = [[UILabel alloc] init];
		_artistNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
	}
	return _artistNameLabel;
}

- (UILabel *)collectionNameLabel {
	if (!_collectionNameLabel) {
		_collectionNameLabel = [[UILabel alloc] init];
		_collectionNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
	}
	return _collectionNameLabel;
}

- (UILabel *)trackTimeMillisLabel {
	if (!_trackTimeMillisLabel) {
		_trackTimeMillisLabel = [[UILabel alloc] init];
		_trackTimeMillisLabel.translatesAutoresizingMaskIntoConstraints = NO;
	}
	return _trackTimeMillisLabel;
}

@end
