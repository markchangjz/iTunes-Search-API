//
//  MKCSerchView.h
//  Media
//
//  Created by MarkChang on 2019/1/26.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKCSerchView;

@protocol MKCSerchViewDelegate <NSObject>

- (void)serchView:(MKCSerchView *)serchView searchKeyword:(NSString *)keyword;

@end

@interface MKCSerchView : UIView

@property (nonatomic, weak) id<MKCSerchViewDelegate> delegate;

@end
