//
//  SHCityModel.m
//  SHMultilevelTable
//
//  Created by Sam on 15/12/26.
//  Copyright © 2015年 Sam. All rights reserved.
//

#import "SHCityModel.h"
#import "SHDistrictModel.h"

@implementation SHCityModel

+ (NSDictionary *)dictionaryWithJsonData:(NSData *)data {
    if (data == nil) {
        return nil;
    }
    
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


+ (NSMutableArray<SHCityModel *> *) createTestCityModelData;
{
    NSString * file = [[NSBundle mainBundle] pathForResource:@"市.info" ofType:nil];
    NSData * data = [NSData dataWithContentsOfFile:file];
    NSDictionary *dic = [self dictionaryWithJsonData:data];
    NSMutableArray<SHCityModel *> *cityArray = [SHCityModel mj_objectArrayWithKeyValuesArray:dic];
    NSMutableArray<SHDistrictModel *> *disArray = [SHDistrictModel createTestDistictModelData];
    [disArray enumerateObjectsUsingBlock:^(SHDistrictModel * disModel, NSUInteger idx, BOOL * _Nonnull stop) {
       [cityArray enumerateObjectsUsingBlock:^(SHCityModel * cityModel, NSUInteger idx, BOOL * _Nonnull stop) {
           if (disModel.CityID == cityModel.CityID) {
               [cityModel.districtArray addObject:disModel];
           }
       }];
    }];
    return cityArray;
}

- (NSMutableArray<SHDistrictModel *> *)districtArray
{
    if (!_districtArray) {
        _districtArray = [NSMutableArray array];
    }
    return _districtArray;
}

@end
