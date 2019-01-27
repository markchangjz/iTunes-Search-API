//
//  MKCCollectedMoviesViewController.m
//  Media
//
//  Created by MarkChang on 2019/1/27.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import "MKCCollectedMoviesViewController.h"
#import "MKCRequestAPI.h"
#import "MKCDataPersistence.h"
#import "MKCJSONModel.h"

@interface MKCCollectedMoviesViewController ()

@end

@implementation MKCCollectedMoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self configureView];
	[self lookupcollectMoviesInfo];
}

#pragma mark - Fetch API

- (void)lookupcollectMoviesInfo {
	NSArray<NSString *> *trackIds = [MKCDataPersistence collectMovieTrackIds];
	
	if (trackIds.count == 0) {
		return;
	}
	
	[[MKCRequestAPI sharedAPI] lookupWithTrackIds:trackIds successHandler:^(NSURLResponse *response, id responseObject) {
		NSLog(@"qaz: %@", responseObject);
		
		NSError *error = nil;
		MKCMovieModel *model = [[MKCMovieModel alloc] initWithDictionary:responseObject error:&error];
		if (error) { // Parse JSON failed
			return;
		}
		
		NSLog(@"%@", model);
		
	} failureHandler:^(NSError *error) {
		
	}];
	
}

#pragma mark - UI Layout

- (void)configureView {
	self.view.backgroundColor = [UIColor whiteColor];
}

@end
