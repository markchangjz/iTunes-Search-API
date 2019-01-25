//
//  MKCRequestAPI+Private.m
//  Media
//
//  Created by MarkChang on 2019/1/25.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import "MKCRequestAPI+Private.h"
#import "AFNetworking.h"

@implementation MKCRequestAPI (Private)

- (NSMutableURLRequest *)in_requestWithURLString:(NSString *)URLString method:(NSString *)method parameters:(NSDictionary *)parameters {
	
	NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:method URLString:URLString parameters:parameters error:nil];
	
	return request;
}

- (NSURLSessionDataTask *)in_fireAPIWithRequest:(NSURLRequest *)request successHandler:(void (^)(NSURLResponse *, id))successHandler failureHandler:(void (^)(NSError *))failureHandler {
	
	NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
	AFURLSessionManager *httpSessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
	
	NSURLSessionDataTask *dataTask = [httpSessionManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
		if (error) {
			if (failureHandler) {
				failureHandler(error);
			}
		} else {
			if (successHandler) {
				successHandler(response, responseObject);
			}
		}
	}];
	[dataTask resume];
	
	return dataTask;
}

@end
