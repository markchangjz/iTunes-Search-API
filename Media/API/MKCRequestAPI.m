//
//  MKCRequestAPI.m
//  Media
//
//  Created by MarkChang on 2019/1/25.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import "MKCRequestAPI.h"
#import "MKCRequestAPI+Private.h"

@implementation MKCRequestAPI

+ (MKCRequestAPI *)sharedAPI {
	static MKCRequestAPI *instance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [[MKCRequestAPI alloc] init];
	});
	return instance;
}

- (NSURLSessionDataTask *)fetchSongWithKeyword:(nonnull NSString *)keyword successHandler:(MKCSuccessHandler)successHandler failureHandler:(MKCFailureHandler)failureHandler {
	
	NSString *URLString = @"https://itunes.apple.com/search";
	
	NSDictionary *parameters = @{@"term": keyword,
								 @"entity": @"song"
								 };
	
	NSMutableURLRequest *request = [self in_requestWithURLString:URLString method:@"GET" parameters:parameters];
	
	NSURLSessionDataTask *dataTask = [self in_fireAPIWithRequest:request successHandler:successHandler failureHandler:failureHandler];
	
	return dataTask;
}

@end
