//
//  MKCMovieTableViewCell.m
//  Media
//
//  Created by MarkChang on 2019/1/26.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import "MKCMovieTableViewCell.h"

@interface MKCMovieTableViewCell()

@property (nonatomic, copy) UILabel *trackNameLabel;
@property (nonatomic, copy) UILabel *artistNameLabel;
@property (nonatomic, copy) UILabel *trackCensoredNameLabel;
@property (nonatomic, copy) UILabel *trackTimeMillisLabel;
@property (nonatomic, copy) UILabel *longDescriptionLabel;

@end

@implementation MKCMovieTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		[self configureContentStackView];
	}
	return self;
}

#pragma mark - UI layout

- (void)configureContentStackView {
	[self.contentStackView addArrangedSubview:self.trackNameLabel];
	[self.contentStackView addArrangedSubview:self.artistNameLabel];
	[self.contentStackView addArrangedSubview:self.trackCensoredNameLabel];
	[self.contentStackView addArrangedSubview:self.trackTimeMillisLabel];
	[self.contentStackView addArrangedSubview:self.longDescriptionLabel];
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

- (void)setTrackCensoredName:(NSString *)trackCensoredName {
	_trackCensoredName = trackCensoredName;
	self.trackCensoredNameLabel.text = trackCensoredName;
}

- (void)setTrackTimeMillis:(NSString *)trackTimeMillis {
	_trackTimeMillis = trackTimeMillis;
	self.trackTimeMillisLabel.text = trackTimeMillis;
}

- (void)setLongDescription:(NSString *)longDescription {
	_longDescription = longDescription;
	self.longDescriptionLabel.text = longDescription;
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

- (UILabel *)trackCensoredNameLabel {
	if (!_trackCensoredNameLabel) {
		_trackCensoredNameLabel = [[UILabel alloc] init];
		_trackCensoredNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
	}
	return _trackCensoredNameLabel;
}

- (UILabel *)trackTimeMillisLabel {
	if (!_trackTimeMillisLabel) {
		_trackTimeMillisLabel = [[UILabel alloc] init];
		_trackTimeMillisLabel.translatesAutoresizingMaskIntoConstraints = NO;
	}
	return _trackTimeMillisLabel;
}

- (UILabel *)longDescriptionLabel {
	if (!_longDescriptionLabel) {
		_longDescriptionLabel = [[UILabel alloc] init];
		_longDescriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
		_longDescriptionLabel.numberOfLines = 2;
		_longDescriptionLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightLight];
	}
	return _longDescriptionLabel;
}

@end