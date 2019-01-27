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

NSString *const movieKey = @"movieKey";
NSString *const songKey = @"songKey";

@implementation MKCDataPersistence

#pragma mark - movie

+ (void)collectMovieWithTrackId:(NSString *)trackId {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSMutableArray *collectedMovies = [userDefaults mutableArrayValueForKey:movieKey];
	[collectedMovies addObject:trackId];
	[userDefaults setObject:[collectedMovies copy] forKey:movieKey];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:MKCCollectedMovieDidChangeNotification object:nil];
}

+ (void)removeCollectedMovieWithTrackId:(NSString *)trackId {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSMutableArray *collectedMovies = [userDefaults mutableArrayValueForKey:movieKey];
	[collectedMovies removeObject:trackId];
	[userDefaults setObject:[collectedMovies copy] forKey:movieKey];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:MKCCollectedMovieDidChangeNotification object:nil];
}

+ (BOOL)hasCollectdMovieWithTrackId:(NSString *)trackId {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSMutableArray *collectedMovies = [userDefaults mutableArrayValueForKey:movieKey];
	return [collectedMovies containsObject:trackId];
}

+ (NSArray<NSString *> *)collectMovieTrackIds {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSMutableArray *collectedMovies = [userDefaults mutableArrayValueForKey:movieKey];
	return collectedMovies;
}

#pragma mark - song

+ (void)collectSongWithTrackId:(nonnull NSString *)trackId {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSMutableArray *collectedSongs = [userDefaults mutableArrayValueForKey:songKey];
	[collectedSongs addObject:trackId];
	[userDefaults setObject:[collectedSongs copy] forKey:songKey];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:MKCCollectedSongDidChangeNotification object:nil];
}

+ (void)removeCollectedSongWithTrackId:(nonnull NSString *)trackId {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSMutableArray *collectedSongs = [userDefaults mutableArrayValueForKey:songKey];
	[collectedSongs removeObject:trackId];
	[userDefaults setObject:[collectedSongs copy] forKey:songKey];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:MKCCollectedSongDidChangeNotification object:nil];
}

+ (BOOL)hasCollectdSongWithTrackId:(nonnull NSString *)trackId {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSMutableArray *collectedSongs = [userDefaults mutableArrayValueForKey:songKey];
	return [collectedSongs containsObject:trackId];
}

+ (NSArray<NSString *> *)collectSongTrackIds {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSMutableArray *collectedSongs = [userDefaults mutableArrayValueForKey:songKey];
	return collectedSongs;
}

@end
