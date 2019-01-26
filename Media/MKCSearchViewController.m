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

#pragma mark - Fetch API

- (void)searchSongAndMovieWithKeyword:(NSString *)keyword {
	self.state = UIStateLoading;
	
	dispatch_group_t group = dispatch_group_create();
	dispatch_queue_global_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	
	dispatch_group_async(group, concurrentQueue, ^{
		dispatch_group_enter(group);
		[self searchSongWithKeyword:keyword completion:^(BOOL success) {
			dispatch_group_leave(group);
		}];
	});
	
	dispatch_group_async(group, concurrentQueue, ^{
		dispatch_group_enter(group);
		[self searchMovieWithKeyword:keyword completion:^(BOOL success) {
			dispatch_group_leave(group);
		}];
	});
	
	dispatch_group_notify(group, dispatch_get_main_queue(), ^{
		self.state = UIStateFinish;
	});
}

- (void)searchSongWithKeyword:(NSString *)keyword completion:(void (^)(BOOL success))completion {
	[[MKCRequestAPI sharedAPI] fetchSongWithKeyword:keyword successHandler:^(NSURLResponse *response, id responseObject) {
		
		NSError *error = nil;
		MKCSongModel *model = [[MKCSongModel alloc] initWithDictionary:responseObject error:&error];
		if (error) { // Parse JSON failed
			completion(NO);
			return;
		}
		
		NSLog(@"song: %@", model.resultCount);
		completion(YES);
	} failureHandler:^(NSError *error) {
		completion(NO);
	}];
}

- (void)searchMovieWithKeyword:(NSString *)keyword completion:(void (^)(BOOL success))completion {
	[[MKCRequestAPI sharedAPI] fetchMovieWithKeyword:keyword successHandler:^(NSURLResponse *response, id responseObject) {
		
		NSError *error = nil;
		MKCMovieModel *model = [[MKCMovieModel alloc] initWithDictionary:responseObject error:&error];
		if (error) { // Parse JSON failed
			completion(NO);
			return;
		}
		
		NSLog(@"movie: %@", model.resultCount);
		completion(YES);
	} failureHandler:^(NSError *error) {
		completion(NO);
	}];
}

#pragma mark - MKCSerchViewDelegate

- (void)serchView:(MKCSerchView *)serchView searchKeyword:(NSString *)keyword {
	[self searchSongAndMovieWithKeyword:keyword];
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
