//
//  MKCMediaCellModel.h
//  Media
//
//  Created by MarkChang on 2019/1/31.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MKCMediaType) {
	MKCMediaTypeMovie,
	MKCMediaTypeSong
};

@interface MKCMediaCellModel : NSObject

@property (nonatomic, strong) JSONModel *mediaInfo;
@property (nonatomic, assign) MKCMediaType type;

@end

NS_ASSUME_NONNULL_END
