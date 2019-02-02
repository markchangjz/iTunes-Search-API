//
//  MKCBasicMediaTableViewCell.m
//  Media
//
//  Created by MarkChang on 2019/1/26.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import "MKCBasicMediaTableViewCell.h"

@interface MKCBasicMediaTableViewCell()

@property (nonatomic, strong) UIStackView *mainStackView;

@end

@implementation MKCBasicMediaTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		[self.contentView addSubview:self.mainStackView];
		
		[self layoutMainStackView];
		[self layoutCoverImageView];
		[self layoutCollectionButton];
	}
	return self;
}

- (void)configureWithModel:(JSONModel *)model {
	
}

#pragma mark - binding

- (void)setIsCollected:(BOOL)isCollected {
	_isCollected = isCollected;
	
	if (isCollected) {
		[self.collectionButton setImage:[UIImage imageNamed:@"collected"] forState:UIControlStateNormal];
	} else {
		[self.collectionButton setImage:[UIImage imageNamed:@"not_collected"] forState:UIControlStateNormal];
	}
}

#pragma mark - UI Layout

- (void)layoutMainStackView {
	[self.mainStackView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:10.0].active = YES;
	[self.mainStackView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-10.0].active = YES;
	[self.mainStackView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:10.0].active = YES;
	[self.mainStackView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-10.0].active = YES;
}

- (void)layoutCoverImageView {
	[self.coverImageView.widthAnchor constraintEqualToConstant:80.0].active = YES;
	[self.coverImageView.heightAnchor constraintEqualToConstant:80.0].active = YES;
}

- (void)layoutCollectionButton {
	[self.collectionButton.widthAnchor constraintEqualToConstant:30.0].active = YES;
	[self.collectionButton.heightAnchor constraintEqualToConstant:30.0].active = YES;
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
	}
	return _collectionButton;
}

- (UIStackView *)mainStackView {
	if (!_mainStackView) {
		_mainStackView = [[UIStackView alloc] init];
		_mainStackView.translatesAutoresizingMaskIntoConstraints = NO;
		_mainStackView.axis = UILayoutConstraintAxisHorizontal;
		_mainStackView.alignment = UIStackViewAlignmentTop;
		_mainStackView.spacing = 10.0;
		[_mainStackView setBackgroundColor:[UIColor redColor]];
		
		[_mainStackView addArrangedSubview:self.coverImageView];
		[_mainStackView addArrangedSubview:self.contentStackView];
		[_mainStackView addArrangedSubview:self.collectionButton];
	}
	return _mainStackView;
}

- (UIStackView *)contentStackView {
	if (!_contentStackView) {
		_contentStackView = [[UIStackView alloc] init];
		_contentStackView.translatesAutoresizingMaskIntoConstraints = NO;
		_contentStackView.axis = UILayoutConstraintAxisVertical;
		_contentStackView.alignment = UIStackViewAlignmentFill;
		_contentStackView.spacing = 2.0;
	}
	return _contentStackView;
}

@end
