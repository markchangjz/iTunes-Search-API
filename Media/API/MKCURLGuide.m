//
//  MKCURLGuide.m
//  Media
//
//  Created by MarkChang on 2019/1/25.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import "MKCURLGuide.h"

@implementation MKCURLGuide

+ (NSString *)iTunesHost {
	return @"https://itunes.apple.com";
}

+ (NSString *)searchAPI {
	return [NSString stringWithFormat:@"%@/search", self.iTunesHost];
}

+ (NSString *)lookupAPI {
	return [NSString stringWithFormat:@"%@/lookup", self.iTunesHost];
}

+ (NSString *)iTunesSupport {
	return @"https://support.apple.com/itunes";
}

@end
