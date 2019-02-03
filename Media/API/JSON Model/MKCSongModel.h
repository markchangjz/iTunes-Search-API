//
//  MKCSongModel.h
//  Media
//
//  Created by MarkChang on 2019/1/25.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol MKCSongInfoModel;

@interface MKCSongInfoModel : JSONModel

@property (nonatomic, copy) NSString <Optional> *trackName;
@property (nonatomic, copy) NSString <Optional> *artistName;
@property (nonatomic, copy) NSString <Optional> *collectionName;
@property (nonatomic, copy) NSNumber <Optional> *trackTimeMillis;
@property (nonatomic, copy) NSString <Optional> *trackViewUrl;
@property (nonatomic, copy) NSString <Optional> *imageUrl;
@property (nonatomic, copy) NSString <Optional> *trackId;

@property (nonatomic, readonly) NSNumber <Ignore> *trackTime;

@end

@interface MKCSongModel : JSONModel

@property (nonatomic, copy) NSString <Optional> *resultCount;
@property (nonatomic, copy) NSArray<MKCSongInfoModel *> <MKCSongInfoModel, Optional> *results;

@end
