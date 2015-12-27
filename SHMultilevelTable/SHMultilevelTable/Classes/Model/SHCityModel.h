//
//  SHCityModel.h
//  SHMultilevelTable
//
//  Created by Sam on 15/12/26.
//  Copyright © 2015年 Sam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
#import "SHDistrictModel.h"
//
//"CityID": 135,
//"name": "东营市",
//"ProID": 15,
//"CitySort": 135

@interface SHCityModel : NSObject

@property (nonatomic,assign) NSInteger CityID;

@property (nonatomic,copy) NSString* name;

@property (nonatomic,assign) NSInteger ProID;

@property (nonatomic,assign) NSInteger CitySort;

@property (nonatomic,copy) NSMutableArray<SHDistrictModel *> *districtArray;

+ (NSMutableArray<SHCityModel *> *) createTestCityModelData;

@end
