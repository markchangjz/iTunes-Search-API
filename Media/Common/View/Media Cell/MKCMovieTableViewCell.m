//
//  MKCMovieTableViewCell.m
//  Media
//
//  Created by MarkChang on 2019/1/26.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import "MKCMovieTableViewCell.h"
#import "MKCMovieModel.h"
#import "UIImageView+WebCache.h"
#import "NSNumber+Formatter.h"

@interface MKCMovieTableViewCell()

@property (nonatomic, copy) UILabel *trackNameLabel;
@property (nonatomic, copy) UILabel *artistNameLabel;
@property (nonatomic, copy) UILabel *trackCensoredNameLabel;
@property (nonatomic, copy) UILabel *trackTimeLabel;
@property (nonatomic, copy) UILabel *longDescriptionLabel;
@property (nonatomic, copy) UIButton *readMoreButton;

@end

@implementation MKCMovieTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		[self configureContentStackView];
		[self.collectionButton addTarget:self action:@selector(collect:) forControlEvents:UIControlEventTouchUpInside];
	}
	return self;
}

#pragma mark - IBAction

- (void)expandCell:(UIButton *)sender {
	if (self.delegate) {
		[self.delegate movieTableViewCell:self expandViewAtIndex:self.tag];
	}
}

- (void)collect:(UIButton *)sender {
	if (self.delegate) {
		[self.delegate movieTableViewCell:self collectMovieAtIndex:self.tag];
	}
}

#pragma mark - Override

- (void)configureWithModel:(JSONModel *)model {
	MKCMovieInfoModel *movie = (MKCMovieInfoModel *)model;
	[self.coverImageView sd_setImageWithURL:[NSURL URLWithString:movie.imageUrl]];
	self.trackName = movie.trackName;
	self.artistName = movie.artistName;
	self.trackCensoredName = movie.trackCensoredName;
	self.duration = movie.trackTime;
	self.longDescription = movie.longDescription;
}

#pragma mark - UI layout

- (void)configureContentStackView {
	[self.contentStackView addArrangedSubview:self.trackNameLabel];
	[self.contentStackView addArrangedSubview:self.artistNameLabel];
	[self.contentStackView addArrangedSubview:self.trackCensoredNameLabel];
	[self.contentStackView addArrangedSubview:self.trackTimeLabel];
	[self.contentStackView addArrangedSubview:self.longDescriptionLabel];
	[self.contentStackView addArrangedSubview:self.readMoreButton];
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

- (void)setDuration:(NSNumber *)duration {
	_duration = duration;
	
	NSString *durationText = [duration durationText];
	self.trackTimeLabel.text = durationText;
	
	if ([durationText isEqualToString:@"0"]) {
		self.trackTimeLabel.hidden = YES;
	} else {
		self.trackTimeLabel.hidden = NO;
	}
}

- (void)setLongDescription:(NSString *)longDescription {
	_longDescription = longDescription;
	self.longDescriptionLabel.text = longDescription;
}

- (void)setIsCollapsed:(BOOL)isCollapsed {
	_isCollapsed = isCollapsed;
	
	self.longDescriptionLabel.numberOfLines = isCollapsed ? 2 : 0;
	self.readMoreButton.hidden = !isCollapsed;
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

- (UILabel *)trackTimeLabel {
	if (!_trackTimeLabel) {
		_trackTimeLabel = [[UILabel alloc] init];
		_trackTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
	}
	return _trackTimeLabel;
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

- (UIButton *)readMoreButton {
	if (!_readMoreButton) {
		_readMoreButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[_readMoreButton setTitle:@"... 更多" forState:UIControlStateNormal];
		[_readMoreButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
		[_readMoreButton addTarget:self action:@selector(expandCell:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _readMoreButton;
}

@end
