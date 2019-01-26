//
//  MKCMovieTableViewCell.h
//  Media
//
//  Created by MarkChang on 2019/1/26.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKCBasicMediaTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKCMovieTableViewCell : MKCBasicMediaTableViewCell

@property (nonatomic, copy) NSString *trackName;
@property (nonatomic, copy) NSString *artistName;
@property (nonatomic, copy) NSString *trackCensoredName;
@property (nonatomic, copy) NSString *trackTimeMillis;
@property (nonatomic, copy) NSString *longDescription;

@end

NS_ASSUME_NONNULL_END
