//
//  SHDistrictModel.h
//  SHMultilevelTable
//
//  Created by Sam on 15/12/26.
//  Copyright © 2015年 Sam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

//"Id": 2822,
//"DisName": "阿拉善左旗",
//"CityID": 362,
//"DisSort": null


@interface SHDistrictModel : NSObject


@property (nonatomic,assign) NSInteger Id;

@property (nonatomic,copy) NSString* DisName;

@property (nonatomic,assign) NSInteger CityID;

@property (nonatomic,assign) NSInteger DisSort;

+ (NSMutableArray<SHDistrictModel *> *) createTestDistictModelData;

@end
