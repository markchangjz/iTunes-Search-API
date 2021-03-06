//
//  MKCRequestAPI.h
//  Media
//
//  Created by MarkChang on 2019/1/25.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void (^MKCSuccessHandler)(NSURLResponse *response, id responseObject);
typedef void (^MKCFailureHandler)(NSError *error);

@interface MKCRequestAPI : NSObject

+ (MKCRequestAPI *)sharedAPI;
+ (AFURLSessionManager *)sessionManager;

- (NSURLSessionDataTask *)searchSongWithKeyword:(nonnull NSString *)keyword successHandler:(MKCSuccessHandler)successHandler failureHandler:(MKCFailureHandler)failureHandler;

- (NSURLSessionDataTask *)searchMovieWithKeyword:(nonnull NSString *)keyword successHandler:(MKCSuccessHandler)successHandler failureHandler:(MKCFailureHandler)failureHandler;

- (NSURLSessionDataTask *)lookupWithTrackIds:(nonnull NSArray<NSString *> *)trackIds successHandler:(MKCSuccessHandler)successHandler failureHandler:(MKCFailureHandler)failureHandler;

@end
