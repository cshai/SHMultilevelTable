//
//  SHProvinceModel.h
//  SHMultilevelTable
//
//  Created by Sam on 15/12/26.
//  Copyright © 2015年 Sam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
#import "SHCityModel.h"


//"ProID": 1,
//"name": "北京市",
//"ProSort": 1,
//"ProRemark": "直辖市"

@interface SHProvinceModel : NSObject

@property (nonatomic,assign) NSInteger ProID;

@property (nonatomic,copy) NSString* name;

@property (nonatomic,assign) NSInteger ProSort;

@property (nonatomic,copy) NSString* ProRemark;

@property (nonatomic,copy) NSMutableArray<SHCityModel *> *cityArray;

+ (NSMutableArray<SHProvinceModel *> *) createTestProvinceModelData;

@end
