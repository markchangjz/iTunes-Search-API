//
//  MKCSerchView.m
//  Media
//
//  Created by MarkChang on 2019/1/26.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import "MKCSerchView.h"

@interface MKCSerchView()

@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UIButton *searchButton;

@end

@implementation MKCSerchView

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		[self addSubview:self.stackView];
		[self configureView];
	}
	
	return self;
}

#pragma mark - IBAction

- (void)searchKeyword:(UIButton *)sender {
	[self.searchTextField resignFirstResponder];
	
	if (self.delegate) {
		[self.delegate serchView:self searchKeyword:self.searchTextField.text];
	}
}

#pragma mark - UI Layout

- (void)configureView {
	[self.searchTextField.widthAnchor constraintEqualToConstant:280.0].active = true;
	
	[self.stackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:10.0].active = true;
	[self.stackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-10.0].active = true;
	[self.stackView.topAnchor constraintEqualToAnchor:self.topAnchor constant:2.0].active = true;
	[self.stackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:2.0].active = true;	
}

#pragma mark - lazy instance

- (UIStackView *)stackView {
	if (!_stackView) {
		_stackView = [[UIStackView alloc] init];
		_stackView.translatesAutoresizingMaskIntoConstraints = NO;
		_stackView.axis = UILayoutConstraintAxisHorizontal;
		_stackView.distribution = UIStackViewDistributionFill;
		_stackView.spacing = 10.0;
		
		[_stackView addArrangedSubview:self.searchTextField];
		[_stackView addArrangedSubview:self.searchButton];
	}
	return _stackView;
}

- (UITextField *)searchTextField {
	if (!_searchTextField) {
		_searchTextField = [[UITextField alloc] init];
		_searchTextField.translatesAutoresizingMaskIntoConstraints = NO;
		_searchTextField.placeholder = @"搜尋";
		_searchTextField.borderStyle = UITextBorderStyleLine;
		_searchTextField.text = @"apple";
	}
	return _searchTextField;
}

- (UIButton *)searchButton {
	if (!_searchButton) {
		_searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		_searchButton.translatesAutoresizingMaskIntoConstraints = NO;
		[_searchButton setTitle:@"搜尋" forState:UIControlStateNormal];
		[_searchButton addTarget:self action:@selector(searchKeyword:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _searchButton;
}

@end
