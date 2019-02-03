//
//  MKCThemeManager.h
//  Media
//
//  Created by MarkChang on 2019/1/31.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKCDataPersistence.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCThemeManager : NSObject

+ (MKCTheme)currentTheme;
+ (void)applyTheme:(MKCTheme)theme;

+ (UIBarStyle)barStyle;

@end

NS_ASSUME_NONNULL_END
