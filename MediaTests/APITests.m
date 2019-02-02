//
//  APITests.m
//  MediaTests
//
//  Created by MarkChang on 2019/2/2.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MKCRequestAPI.h"
#import "MKCJSONModel.h"

@interface APITests : XCTestCase

@end

@implementation APITests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testSearchMovie {
	XCTestExpectation *expectation = [self expectationWithDescription:@"wait"];
	
	[[MKCRequestAPI sharedAPI] searchMovieWithKeyword:@"apple" successHandler:^(NSURLResponse *response, id responseObject) {
		
		[expectation fulfill];
		
		NSError *error = nil;
		MKCMovieModel *model = [[MKCMovieModel alloc] initWithDictionary:responseObject error:&error];
		if (error) {
			XCTFail(@"error %@", error);
		}
		
		XCTAssertNotNil(model);
	} failureHandler:^(NSError *error) {
		XCTFail(@"error %@", error);
	}];
	
	[self waitForExpectationsWithTimeout:3.0 handler:nil];
}

- (void)testSearchSong {
	XCTestExpectation *expectation = [self expectationWithDescription:@"wait"];
	
	[[MKCRequestAPI sharedAPI] searchSongWithKeyword:@"apple" successHandler:^(NSURLResponse *response, id responseObject) {
		
		[expectation fulfill];
		
		NSError *error = nil;
		MKCSongModel *model = [[MKCSongModel alloc] initWithDictionary:responseObject error:&error];
		if (error) {
			XCTFail(@"error %@", error);
		}
		
		XCTAssertNotNil(model);
	} failureHandler:^(NSError *error) {
		XCTFail(@"error %@", error);
	}];
	
	[self waitForExpectationsWithTimeout:3.0 handler:nil];
}

- (void)testLookupMovie {
	XCTestExpectation *expectation = [self expectationWithDescription:@"wait"];
	
	[[MKCRequestAPI sharedAPI] lookupWithTrackIds:@[@"1115736170", @"1410086013"] successHandler:^(NSURLResponse *response, id responseObject) {
		
		[expectation fulfill];
		
		NSError *error = nil;
		MKCMovieModel *model = [[MKCMovieModel alloc] initWithDictionary:responseObject error:&error];
		if (error) {
			XCTFail(@"error %@", error);
		}
		
		XCTAssertNotNil(model);
		XCTAssertEqual(model.resultCount.integerValue, 2);
	} failureHandler:^(NSError *error) {
		XCTFail(@"error %@", error);
	}];
	
	[self waitForExpectationsWithTimeout:3.0 handler:nil];
}

- (void)testLookupSong {
	XCTestExpectation *expectation = [self expectationWithDescription:@"wait"];
	
	[[MKCRequestAPI sharedAPI] lookupWithTrackIds:@[@"944194273", @"454437498"] successHandler:^(NSURLResponse *response, id responseObject) {
		
		[expectation fulfill];
		
		NSError *error = nil;
		MKCSongModel *model = [[MKCSongModel alloc] initWithDictionary:responseObject error:&error];
		if (error) {
			XCTFail(@"error %@", error);
		}
		
		XCTAssertNotNil(model);
		XCTAssertEqual(model.resultCount.integerValue, 2);
	} failureHandler:^(NSError *error) {
		XCTFail(@"error %@", error);
	}];
	
	[self waitForExpectationsWithTimeout:3.0 handler:nil];
}

@end
