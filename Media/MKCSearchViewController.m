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

@end

@implementation MKCSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
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

#pragma mark - UI Layout

- (void)configureView {
	self.view.backgroundColor = [UIColor whiteColor];
	self.navigationItem.titleView = self.serchView;
}

#pragma mark - lazy instance

- (MKCSerchView *)serchView {
	if (!_serchView) {
		_serchView = [[MKCSerchView alloc] init];
		_serchView.delegate = self;
	}
	return _serchView;
}

@end
