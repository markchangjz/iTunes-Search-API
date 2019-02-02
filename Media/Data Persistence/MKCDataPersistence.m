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

@implementation MKCDataPersistence

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
	[collectedMovies addObject:trackId];
	[self.userDefaults setObject:[collectedMovies copy] forKey:MKCCollectedMoviesKey];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:MKCCollectedMovieDidChangeNotification object:nil];
}

+ (void)removeCollectedMovieWithTrackId:(NSString *)trackId {
	NSMutableArray *collectedMovies = [self.userDefaults mutableArrayValueForKey:MKCCollectedMoviesKey];
	[collectedMovies removeObject:trackId];
	[self.userDefaults setObject:[collectedMovies copy] forKey:MKCCollectedMoviesKey];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:MKCCollectedMovieDidChangeNotification object:nil];
}

+ (BOOL)hasCollectdMovieWithTrackId:(NSString *)trackId {
	NSMutableArray *collectedMovies = [self.userDefaults mutableArrayValueForKey:MKCCollectedMoviesKey];
	return [collectedMovies containsObject:trackId];
}

+ (NSArray<NSString *> *)collectMovieTrackIds {
	NSMutableArray *collectedMovies = [self.userDefaults mutableArrayValueForKey:MKCCollectedMoviesKey];
	return collectedMovies;
}

#pragma mark - song

+ (void)collectSongWithTrackId:(nonnull NSString *)trackId {
	NSMutableArray *collectedSongs = [self.userDefaults mutableArrayValueForKey:MKCCollectedSongsKey];
	[collectedSongs addObject:trackId];
	[self.userDefaults setObject:[collectedSongs copy] forKey:MKCCollectedSongsKey];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:MKCCollectedSongDidChangeNotification object:nil];
}

+ (void)removeCollectedSongWithTrackId:(nonnull NSString *)trackId {
	NSMutableArray *collectedSongs = [self.userDefaults mutableArrayValueForKey:MKCCollectedSongsKey];
	[collectedSongs removeObject:trackId];
	[self.userDefaults setObject:[collectedSongs copy] forKey:MKCCollectedSongsKey];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:MKCCollectedSongDidChangeNotification object:nil];
}

+ (BOOL)hasCollectdSongWithTrackId:(nonnull NSString *)trackId {
	NSMutableArray *collectedSongs = [self.userDefaults mutableArrayValueForKey:MKCCollectedSongsKey];
	return [collectedSongs containsObject:trackId];
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
