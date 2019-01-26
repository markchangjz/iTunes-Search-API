//
//  MKCSearchViewController.m
//  Media
//
//  Created by MarkChang on 2019/1/26.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import "MKCSearchViewController.h"
#import "MKCRequestAPI.h"
#import "MKCJSONModel.h"
#import "MKCSerchView.h"

@interface MKCSearchViewController () <MKCSerchViewDelegate>

@property (nonatomic, strong) MKCSerchView *serchView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation MKCSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self configureView];
}

#pragma mark - MKCSerchViewDelegate

- (void)serchView:(MKCSerchView *)serchView searchKeyword:(NSString *)keyword {
	
	[[MKCRequestAPI sharedAPI] fetchSongWithKeyword:keyword successHandler:^(NSURLResponse *response, id responseObject) {
		
		NSError *error = nil;
		MKCSongModel *model = [[MKCSongModel alloc] initWithDictionary:responseObject error:&error];
		if (error) { // Parse JSON failed
			
			return;
		}
		
		NSLog(@"song: %@", model.resultCount);
		
	} failureHandler:^(NSError *error) {
		
	}];
	
	[[MKCRequestAPI sharedAPI] fetchMovieWithKeyword:keyword successHandler:^(NSURLResponse *response, id responseObject) {
		
		NSError *error = nil;
		MKCMovieModel *model = [[MKCMovieModel alloc] initWithDictionary:responseObject error:&error];
		if (error) { // Parse JSON failed
			
			return;
		}
		
		NSLog(@"movie: %@", model.resultCount);
		
	} failureHandler:^(NSError *error) {
		
	}];
}

#pragma mark - UI State

- (void)setState:(UIState)state {
	_state = state;
	
	dispatch_async(dispatch_get_main_queue(), ^{
		[self configureStateView];
	});
}

- (void)configureStateView {
	switch (self.state) {
		case UIStateLoading:
			[self configureLoadingStateView];
			break;
		case UIStateFinish:
			[self configureFinishStateView];
			break;
		case UIStateError:
			[self configureErrorStateView];
			break;
	}
}

- (void)configureLoadingStateView {
	[self.activityIndicatorView startAnimating];
}

- (void)configureFinishStateView {
	[self.activityIndicatorView stopAnimating];
}

- (void)configureErrorStateView {
	[self.activityIndicatorView stopAnimating];
}

#pragma mark - UI Layout

- (void)configureView {
	self.view.backgroundColor = [UIColor whiteColor];
	self.navigationItem.titleView = self.serchView;
	
	// loading view
	[self.view addSubview:self.activityIndicatorView];
	[self layoutActivityIndicatorView];
}

- (void)layoutActivityIndicatorView {
	[self.activityIndicatorView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
	[self.activityIndicatorView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
}

#pragma mark - lazy instance

- (MKCSerchView *)serchView {
	if (!_serchView) {
		_serchView = [[MKCSerchView alloc] init];
		_serchView.delegate = self;
	}
	return _serchView;
}

- (UIActivityIndicatorView *)activityIndicatorView {
	if (!_activityIndicatorView) {
		_activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		_activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
	}
	return _activityIndicatorView;
}

@end
