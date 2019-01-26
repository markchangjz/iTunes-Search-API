//
//  MKCSearchViewController.h
//  Media
//
//  Created by MarkChang on 2019/1/26.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UIState) {
	UIStateLoading = 0,
	UIStateFinish,
	UIStateError
};

@interface MKCSearchViewController : UIViewController

@property (nonatomic, assign) UIState state;

@end
