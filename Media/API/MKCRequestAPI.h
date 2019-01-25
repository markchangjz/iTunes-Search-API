//
//  MKCRequestAPI.h
//  Media
//
//  Created by MarkChang on 2019/1/25.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^MKCSuccessHandler)(NSURLResponse *response, id responseObject);
typedef void (^MKCFailureHandler)(NSError *error);

@interface MKCRequestAPI : NSObject

+ (MKCRequestAPI *)sharedAPI;

- (NSURLSessionDataTask *)fetchSongWithKeyword:(nonnull NSString *)keyword successHandler:(MKCSuccessHandler)successHandler failureHandler:(MKCFailureHandler)failureHandler;

- (NSURLSessionDataTask *)fetchMovieWithKeyword:(nonnull NSString *)keyword successHandler:(MKCSuccessHandler)successHandler failureHandler:(MKCFailureHandler)failureHandler;

@end
