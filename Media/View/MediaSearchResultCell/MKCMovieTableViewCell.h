//
//  MKCMovieTableViewCell.h
//  Media
//
//  Created by MarkChang on 2019/1/26.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKCBasicMediaTableViewCell.h"

@class MKCMovieTableViewCell;

@protocol MKCMovieTableViewCellDelegate <NSObject>

- (void)movieTableViewCell:(MKCMovieTableViewCell *)movieTableViewCell collectMovieAtIndex:(NSInteger)index;
- (void)movieTableViewCell:(MKCMovieTableViewCell *)movieTableViewCell expandViewAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_BEGIN

@interface MKCMovieTableViewCell : MKCBasicMediaTableViewCell

@property (nonatomic, weak) id<MKCMovieTableViewCellDelegate> delegate;
@property (nonatomic, copy) NSString *trackName;
@property (nonatomic, copy) NSString *artistName;
@property (nonatomic, copy) NSString *trackCensoredName;
@property (nonatomic, copy) NSString *trackTimeMillis;
@property (nonatomic, copy) NSString *longDescription;
@property (nonatomic, assign) BOOL isCollapsed;

@end

NS_ASSUME_NONNULL_END
