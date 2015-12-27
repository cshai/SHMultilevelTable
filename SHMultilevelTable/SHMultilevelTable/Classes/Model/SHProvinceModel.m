//
//  SHProvinceModel.m
//  SHMultilevelTable
//
//  Created by Sam on 15/12/26.
//  Copyright © 2015年 Sam. All rights reserved.
//

#import "SHProvinceModel.h"

@implementation SHProvinceModel

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

+ (NSMutableArray<SHProvinceModel *> *) createTestProvinceModelData;
{
    NSString * file = [[NSBundle mainBundle] pathForResource:@"省.info" ofType:nil];
    NSData * data = [NSData dataWithContentsOfFile:file];
    NSDictionary *dic = [self dictionaryWithJsonData:data];
    NSMutableArray<SHProvinceModel *> *proArray = [SHProvinceModel mj_objectArrayWithKeyValuesArray:dic];
    NSMutableArray<SHCityModel *> *cityArray = [SHCityModel createTestCityModelData];
    [cityArray enumerateObjectsUsingBlock:^(SHCityModel * _Nonnull cityModel, NSUInteger idx, BOOL * _Nonnull stop) {
       [proArray enumerateObjectsUsingBlock:^(SHProvinceModel * _Nonnull proModel, NSUInteger idx, BOOL * _Nonnull stop) {
           if (proModel.ProID == cityModel.ProID) {
               [proModel.cityArray addObject:cityModel];
           }
       }];
    }];
    return proArray;
}

- (NSMutableArray<SHCityModel *> *)cityArray
{
    if (!_cityArray) {
        _cityArray = [NSMutableArray array];
    }
    return _cityArray;
}


@end
