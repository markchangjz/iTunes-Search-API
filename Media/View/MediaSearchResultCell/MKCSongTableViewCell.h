//
//  MKCSongTableViewCell.h
//  Media
//
//  Created by MarkChang on 2019/1/26.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKCBasicMediaTableViewCell.h"

@class MKCSongTableViewCell;

@protocol MKCSongTableViewCellDelegate <NSObject>

- (void)songTableViewCell:(MKCSongTableViewCell *)songTableViewCell collectSongAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_BEGIN

@interface MKCSongTableViewCell : MKCBasicMediaTableViewCell

@property (nonatomic, weak) id<MKCSongTableViewCellDelegate> delegate;
@property (nonatomic, copy) NSString *trackName;
@property (nonatomic, copy) NSString *artistName;
@property (nonatomic, copy) NSString *collectionName;
@property (nonatomic, copy) NSString *trackTimeMillis;

@end

NS_ASSUME_NONNULL_END
