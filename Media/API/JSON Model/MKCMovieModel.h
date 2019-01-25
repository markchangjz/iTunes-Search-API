//
//  MKCMovieModel.h
//  Media
//
//  Created by MarkChang on 2019/1/25.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol MKCMovieInfoModel;

@interface MKCMovieInfoModel : JSONModel

@property (nonatomic, copy) NSString <Optional> *trackName;
@property (nonatomic, copy) NSString <Optional> *artistName;
@property (nonatomic, copy) NSString <Optional> *trackCensoredName;
@property (nonatomic, copy) NSString <Optional> *trackTimeMillis;
@property (nonatomic, copy) NSString <Optional> *longDescription;
@property (nonatomic, copy) NSString <Optional> *trackViewUrl;

@end

@interface MKCMovieModel : JSONModel

@property (nonatomic, copy) NSString <Optional> *resultCount;
@property (nonatomic, copy) NSArray<MKCMovieInfoModel *> <MKCMovieInfoModel, Optional> *results;

@end

