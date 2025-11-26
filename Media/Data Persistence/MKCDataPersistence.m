//
//  MKCDataPersistence.m
//  Media
//
//  Created by MarkChang on 2019/1/26.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import "MKCDataPersistence.h"

NSString *const MKCCollectedMovieDidChangeNotification = @"MKCCollectedMovieDidChangeNotification";
NSString *const MKCCollectedSongDidChangeNotification = @"MKCCollectedSongDidChangeNotification";
NSString *const MKCThemeDidChangeNotification = @"MKCThemeDidChangeNotification";

NSString *const MKCCollectedMoviesKey = @"MKCCollectedMoviesKey";
NSString *const MKCCollectedSongsKey = @"MKCCollectedSongsKey";
NSString *const MKCThemeKey = @"MKCThemeKey";

@interface MKCDataPersistence ()

@property (class, nonatomic, strong) NSSet<NSString *> *cachedCollectedMovieTrackIds;
@property (class, nonatomic, strong) NSSet<NSString *> *cachedCollectedSongTrackIds;

@end

@implementation MKCDataPersistence

static NSSet<NSString *> *_cachedCollectedMovieTrackIds = nil;
static NSSet<NSString *> *_cachedCollectedSongTrackIds = nil;

+ (NSSet<NSString *> *)cachedCollectedMovieTrackIds {
	if (!_cachedCollectedMovieTrackIds) {
		[self reloadCachedCollectedMovieTrackIds];
	}
	return _cachedCollectedMovieTrackIds;
}

+ (void)setCachedCollectedMovieTrackIds:(NSSet<NSString *> *)cachedCollectedMovieTrackIds {
	_cachedCollectedMovieTrackIds = cachedCollectedMovieTrackIds;
}

+ (NSSet<NSString *> *)cachedCollectedSongTrackIds {
	if (!_cachedCollectedSongTrackIds) {
		[self reloadCachedCollectedSongTrackIds];
	}
	return _cachedCollectedSongTrackIds;
}

+ (void)setCachedCollectedSongTrackIds:(NSSet<NSString *> *)cachedCollectedSongTrackIds {
	_cachedCollectedSongTrackIds = cachedCollectedSongTrackIds;
}

+ (void)reloadCachedCollectedMovieTrackIds {
	NSArray<NSString *> *trackIds = [self.userDefaults arrayForKey:MKCCollectedMoviesKey] ?: @[];
	_cachedCollectedMovieTrackIds = [NSSet setWithArray:trackIds];
}

+ (void)reloadCachedCollectedSongTrackIds {
	NSArray<NSString *> *trackIds = [self.userDefaults arrayForKey:MKCCollectedSongsKey] ?: @[];
	_cachedCollectedSongTrackIds = [NSSet setWithArray:trackIds];
}

+ (NSUserDefaults *)userDefaults {
	return [NSUserDefaults standardUserDefaults];
}

+ (void)setDefaultValue {
	[self.userDefaults registerDefaults:@{MKCThemeKey: @(MKCThemeLight),
										  }];

}

#pragma mark - movie

+ (void)collectMovieWithTrackId:(NSString *)trackId {
	NSMutableArray *collectedMovies = [self.userDefaults mutableArrayValueForKey:MKCCollectedMoviesKey];
	if (![collectedMovies containsObject:trackId]) {
		[collectedMovies addObject:trackId];
		[self.userDefaults setObject:[collectedMovies copy] forKey:MKCCollectedMoviesKey];
		[self reloadCachedCollectedMovieTrackIds];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:MKCCollectedMovieDidChangeNotification object:nil];
	}
}

+ (void)removeCollectedMovieWithTrackId:(NSString *)trackId {
	NSMutableArray *collectedMovies = [self.userDefaults mutableArrayValueForKey:MKCCollectedMoviesKey];
	if ([collectedMovies containsObject:trackId]) {
		[collectedMovies removeObject:trackId];
		[self.userDefaults setObject:[collectedMovies copy] forKey:MKCCollectedMoviesKey];
		[self reloadCachedCollectedMovieTrackIds];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:MKCCollectedMovieDidChangeNotification object:nil];
	}
}

+ (BOOL)hasCollectdMovieWithTrackId:(NSString *)trackId {
	return [[self cachedCollectedMovieTrackIds] containsObject:trackId];
}

+ (NSArray<NSString *> *)collectMovieTrackIds {
	NSMutableArray *collectedMovies = [self.userDefaults mutableArrayValueForKey:MKCCollectedMoviesKey];
	return collectedMovies;
}

#pragma mark - song

+ (void)collectSongWithTrackId:(nonnull NSString *)trackId {
	NSMutableArray *collectedSongs = [self.userDefaults mutableArrayValueForKey:MKCCollectedSongsKey];
	if (![collectedSongs containsObject:trackId]) {
		[collectedSongs addObject:trackId];
		[self.userDefaults setObject:[collectedSongs copy] forKey:MKCCollectedSongsKey];
		[self reloadCachedCollectedSongTrackIds];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:MKCCollectedSongDidChangeNotification object:nil];
	}
}

+ (void)removeCollectedSongWithTrackId:(nonnull NSString *)trackId {
	NSMutableArray *collectedSongs = [self.userDefaults mutableArrayValueForKey:MKCCollectedSongsKey];
	if ([collectedSongs containsObject:trackId]) {
		[collectedSongs removeObject:trackId];
		[self.userDefaults setObject:[collectedSongs copy] forKey:MKCCollectedSongsKey];
		[self reloadCachedCollectedSongTrackIds];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:MKCCollectedSongDidChangeNotification object:nil];
	}
}

+ (BOOL)hasCollectdSongWithTrackId:(nonnull NSString *)trackId {
	return [[self cachedCollectedSongTrackIds] containsObject:trackId];
}

+ (NSArray<NSString *> *)collectSongTrackIds {
	NSMutableArray *collectedSongs = [self.userDefaults mutableArrayValueForKey:MKCCollectedSongsKey];
	return collectedSongs;
}

#pragma mark - theme

+ (void)setTheme:(MKCTheme)theme {
	[self.userDefaults setInteger:theme forKey:MKCThemeKey];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:MKCThemeDidChangeNotification object:nil];
}

+ (MKCTheme)theme {
	return [self.userDefaults integerForKey:MKCThemeKey];
}

@end
