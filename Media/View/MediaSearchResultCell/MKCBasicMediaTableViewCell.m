//
//  MKCBasicMediaTableViewCell.m
//  Media
//
//  Created by MarkChang on 2019/1/26.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import "MKCBasicMediaTableViewCell.h"

@interface MKCBasicMediaTableViewCell()

@property (nonatomic, strong) UIButton *collectionButton;

@end

@implementation MKCBasicMediaTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		[self.contentView addSubview:self.coverImageView];
		[self layoutCoverImageView];
		
		[self.contentView addSubview:self.collectionButton];
		[self layoutCollectionButton];
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	self.contentView.frame = UIEdgeInsetsInsetRect(self.contentView.frame, UIEdgeInsetsMake(0, 16, 0, 16));
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - IBAction

- (void)collect:(UIButton *)sender {
	
}

#pragma mark - UI Layout

- (void)layoutCoverImageView {
	[self.coverImageView.widthAnchor constraintEqualToConstant:80.0].active = YES;
	[self.coverImageView.heightAnchor constraintEqualToConstant:80.0].active = YES;

	[self.coverImageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:20.0].active = YES;
	[self.coverImageView.bottomAnchor constraintLessThanOrEqualToAnchor:self.contentView.bottomAnchor constant:-20.0].active = YES;
}

- (void)layoutCollectionButton {
	[self.collectionButton.widthAnchor constraintEqualToConstant:30.0].active = YES;
	[self.collectionButton.heightAnchor constraintEqualToConstant:30.0].active = YES;
	
	[self.collectionButton.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:0.0].active = YES;
	[self.collectionButton.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
}

#pragma mark - lazy instance

- (UIImageView *)coverImageView {
	if (!_coverImageView) {
		_coverImageView = [[UIImageView alloc] init];
		_coverImageView.translatesAutoresizingMaskIntoConstraints = NO;
		_coverImageView.backgroundColor = [UIColor lightGrayColor];
	}
	return _coverImageView;
}

- (UIButton *)collectionButton {
	if (!_collectionButton) {
		_collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_collectionButton.translatesAutoresizingMaskIntoConstraints = NO;
		[_collectionButton setImage:[UIImage imageNamed:@"not_collected"] forState:UIControlStateNormal];
		[_collectionButton addTarget:self action:@selector(collect:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _collectionButton;
}

@end
