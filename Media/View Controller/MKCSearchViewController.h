//
//  MKCSearchViewController.h
//  Media
//
//  Created by MarkChang on 2019/1/26.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKCBasicViewController.h"

typedef NS_ENUM(NSUInteger, UIState) {
	UIStateBlank,
	UIStateLoading,
	UIStateFinish,
	UIStateError
};

@interface MKCSearchViewController : MKCBasicViewController

@property (nonatomic, assign) UIState state;

@end
