//
//  MKCDataPersistence.m
//  Media
//
//  Created by MarkChang on 2019/1/26.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import "MKCDataPersistence.h"

NSString * const movieKey = @"movieKey";

@implementation MKCDataPersistence

+ (void)collectMovieWithTrackId:(NSString *)trackId {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSMutableArray *collectedMovies = [userDefaults mutableArrayValueForKey:movieKey];
	[collectedMovies addObject:trackId];
	[userDefaults setObject:collectedMovies forKey:movieKey];
}

+ (void)removeCollectedMovieWithTrackId:(NSString *)trackId {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSMutableArray *collectedMovies = [userDefaults mutableArrayValueForKey:movieKey];
	[collectedMovies removeObject:trackId];
	[userDefaults setObject:collectedMovies forKey:movieKey];
}

+ (BOOL)hasCollectdMovieWithTrackId:(NSString *)trackId {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSMutableArray *collectedMovies = [userDefaults mutableArrayValueForKey:movieKey];
	return [collectedMovies containsObject:trackId];
}

@end
