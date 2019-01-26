//
//  MKCDataPersistence.h
//  Media
//
//  Created by MarkChang on 2019/1/26.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const movieKey;
extern NSString *const songKey;

@interface MKCDataPersistence : NSObject

#pragma mark - movie

+ (void)collectMovieWithTrackId:(nonnull NSString *)trackId;
+ (void)removeCollectedMovieWithTrackId:(nonnull NSString *)trackId;
+ (BOOL)hasCollectdMovieWithTrackId:(nonnull NSString *)trackId;

#pragma mark - song

+ (void)collectSongWithTrackId:(nonnull NSString *)trackId;
+ (void)removeCollectedSongWithTrackId:(nonnull NSString *)trackId;
+ (BOOL)hasCollectdSongWithTrackId:(nonnull NSString *)trackId;

@end

NS_ASSUME_NONNULL_END
