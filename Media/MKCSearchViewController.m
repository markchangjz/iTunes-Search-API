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

@interface MKCSearchViewController ()

@end

@implementation MKCSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.view.backgroundColor = [UIColor whiteColor];
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
	view.backgroundColor = UIColor.redColor;
	
	self.navigationItem.titleView = view;
	
	[[MKCRequestAPI sharedAPI] fetchMovieWithKeyword:@"apple" successHandler:^(NSURLResponse *response, id responseObject) {
		
		NSError *error = nil;
		MKCMovieModel *model = [[MKCMovieModel alloc] initWithDictionary:responseObject error:&error];
		if (error) { // Parse JSON failed
			
			return;
		}
		
		NSLog(@"qaz: %@", model.results[0].artistName);
		
		
		NSLog(@"movie: %@", responseObject);
	} failureHandler:^(NSError *error) {
		
	}];
	
	[[MKCRequestAPI sharedAPI] fetchSongWithKeyword:@"apple" successHandler:^(NSURLResponse *response, id responseObject) {
		
		NSError *error = nil;
		MKCSongModel *model = [[MKCSongModel alloc] initWithDictionary:responseObject error:&error];
		if (error) { // Parse JSON failed
			
			return;
		}
		
		NSLog(@"qaz: %@", model.results[0].artistName);
		
		
		NSLog(@"song: %@", responseObject);
	} failureHandler:^(NSError *error) {
		
	}];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
