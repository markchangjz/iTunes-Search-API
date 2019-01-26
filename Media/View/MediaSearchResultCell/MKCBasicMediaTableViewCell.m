//
//  MKCBasicMediaTableViewCell.m
//  Media
//
//  Created by MarkChang on 2019/1/26.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import "MKCBasicMediaTableViewCell.h"

@implementation MKCBasicMediaTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		[self.contentView addSubview:self.coverImageView];
		[self layoutCoverImageView];
		
		
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

#pragma mark - UI Layout

- (void)layoutCoverImageView {
	[self.coverImageView.widthAnchor constraintEqualToConstant:80.0].active = YES;
	[self.coverImageView.heightAnchor constraintEqualToConstant:80.0].active = YES;

	[self.coverImageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:20.0].active = YES;
	[self.coverImageView.bottomAnchor constraintLessThanOrEqualToAnchor:self.contentView.bottomAnchor constant:-20.0].active = YES;
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

@end
