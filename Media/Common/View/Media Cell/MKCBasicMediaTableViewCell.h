//
//  MKCBasicMediaTableViewCell.h
//  Media
//
//  Created by MarkChang on 2019/1/26.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKCBasicTableViewCell.h"
#import "JSONModel.h"

@interface MKCBasicMediaTableViewCell : MKCBasicTableViewCell

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIStackView *contentStackView;
@property (nonatomic, strong) UIButton *collectionButton;
@property (nonatomic, assign) BOOL isCollected;

- (void)configureWithModel:(JSONModel *)model;

@end
