//
//  NSNumber+Formatter.h
//  Media
//
//  Created by MarkChang on 2019/1/27.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNumber (Formatter)

- (NSString *)decimalText;

- (NSString *)durationText;

@end

NS_ASSUME_NONNULL_END
