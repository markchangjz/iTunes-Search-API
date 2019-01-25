//
//  MKCRequestAPI.m
//  Media
//
//  Created by MarkChang on 2019/1/25.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import "MKCRequestAPI.h"

@implementation MKCRequestAPI

+ (MKCRequestAPI *)sharedAPI {
	static MKCRequestAPI *instance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [[MKCRequestAPI alloc] init];
	});
	return instance;
}

@end
