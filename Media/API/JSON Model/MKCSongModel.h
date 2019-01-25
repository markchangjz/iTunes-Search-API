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

@property (nonatomic, copy) NSString *trackName;
@property (nonatomic, copy) NSString *artistName;
@property (nonatomic, copy) NSString *collectionName;
@property (nonatomic, copy) NSString *trackTimeMillis;
@property (nonatomic, copy) NSString *trackViewUrl;

@end

@interface MKCSongModel : JSONModel

@property (nonatomic, copy) NSString *resultCount;
@property (nonatomic, copy) NSArray<MKCSongInfoModel *> <MKCSongInfoModel> *results;

@end
