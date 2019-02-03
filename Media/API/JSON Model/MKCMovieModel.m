//
//  MKCMovieModel.m
//  Media
//
//  Created by MarkChang on 2019/1/25.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import "MKCMovieModel.h"

@implementation MKCMovieInfoModel

+ (JSONKeyMapper *)keyMapper {
	return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"imageUrl": @"artworkUrl100"}];
}

- (NSNumber<Ignore> *)trackTime {
	return @(self.trackTimeMillis.integerValue / 1000);
}

@end

@implementation MKCMovieModel

@end
