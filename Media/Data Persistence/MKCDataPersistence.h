//
//  MKCDataPersistence.h
//  Media
//
//  Created by MarkChang on 2019/1/26.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const MKCCollectedMovieDidChangeNotification;
extern NSString *const MKCCollectedSongDidChangeNotification;

extern NSString *const movieKey;
extern NSString *const songKey;
extern NSString *const MKCThemeKey;

typedef NS_ENUM(NSInteger, MKCTheme) {
	MKCThemeLight,
	MKCThemeDark
};

@interface MKCDataPersistence : NSObject

+ (void)setDefaultValue;

#pragma mark - movie

+ (void)collectMovieWithTrackId:(nonnull NSString *)trackId;
+ (void)removeCollectedMovieWithTrackId:(nonnull NSString *)trackId;
+ (BOOL)hasCollectdMovieWithTrackId:(nonnull NSString *)trackId;
+ (NSArray<NSString *> *)collectMovieTrackIds;

#pragma mark - song

+ (void)collectSongWithTrackId:(nonnull NSString *)trackId;
+ (void)removeCollectedSongWithTrackId:(nonnull NSString *)trackId;
+ (BOOL)hasCollectdSongWithTrackId:(nonnull NSString *)trackId;
+ (NSArray<NSString *> *)collectSongTrackIds;

#pragma mark - theme

+ (void)setTheme:(MKCTheme)theme;
+ (MKCTheme)theme;

@end

NS_ASSUME_NONNULL_END
