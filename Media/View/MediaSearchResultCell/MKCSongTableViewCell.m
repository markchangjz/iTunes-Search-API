//
//  MKCSongTableViewCell.m
//  Media
//
//  Created by MarkChang on 2019/1/26.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import "MKCSongTableViewCell.h"

@interface MKCSongTableViewCell()

@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, copy) UILabel *trackNameLabel;
@property (nonatomic, copy) UILabel *artistNameLabel;
@property (nonatomic, copy) UILabel *collectionNameLabel;
@property (nonatomic, copy) UILabel *trackTimeMillisLabel;

@end

@implementation MKCSongTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		[self.contentView addSubview:self.stackView];
		[self layoutStackView];
	}
	return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UI layout

- (void)layoutStackView {
	[self.stackView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:10.0].active = YES;
	[self.stackView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-10.0].active = YES;
	
	id coverImageView = self.coverImageView;
	id stackView = self.stackView;
	id collectionButton = self.collectionButton;
	NSDictionary *views = NSDictionaryOfVariableBindings(coverImageView, stackView, collectionButton);

	NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[coverImageView]-10-[stackView][collectionButton]" options:0 metrics:nil views:views];
	[self.contentView addConstraints:constraints];
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

- (UIStackView *)stackView {
	if (!_stackView) {
		_stackView = [[UIStackView alloc] init];
		_stackView.translatesAutoresizingMaskIntoConstraints = NO;
		_stackView.axis = UILayoutConstraintAxisVertical;
		_stackView.distribution = UIStackViewDistributionFill;
		_stackView.spacing = 2.0;
		
		[_stackView addArrangedSubview:self.trackNameLabel];
		[_stackView addArrangedSubview:self.artistNameLabel];
		[_stackView addArrangedSubview:self.collectionNameLabel];
		[_stackView addArrangedSubview:self.trackTimeMillisLabel];
	}
	return _stackView;
}

- (UILabel *)trackNameLabel {
	if (!_trackNameLabel) {
		_trackNameLabel = [[UILabel alloc] init];
		_trackNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
		_trackNameLabel.text = @"trackNameLabel";
	}
	return _trackNameLabel;
}

- (UILabel *)artistNameLabel {
	if (!_artistNameLabel) {
		_artistNameLabel = [[UILabel alloc] init];
		_artistNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
		_artistNameLabel.text = @"artistNameLabel";
	}
	return _artistNameLabel;
}

- (UILabel *)collectionNameLabel {
	if (!_collectionNameLabel) {
		_collectionNameLabel = [[UILabel alloc] init];
		_collectionNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
		_collectionNameLabel.text = @"collectionNameLabel";
	}
	return _collectionNameLabel;
}

- (UILabel *)trackTimeMillisLabel {
	if (!_trackTimeMillisLabel) {
		_trackTimeMillisLabel = [[UILabel alloc] init];
		_trackTimeMillisLabel.translatesAutoresizingMaskIntoConstraints = NO;
		_trackTimeMillisLabel.text = @"trackTimeMillisLabel";
	}
	return _trackTimeMillisLabel;
}

@end
