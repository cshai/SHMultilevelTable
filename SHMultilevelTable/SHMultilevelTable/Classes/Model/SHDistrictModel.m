//
//  SHDistrictModel.m
//  SHMultilevelTable
//
//  Created by Sam on 15/12/26.
//  Copyright © 2015年 Sam. All rights reserved.
//

#import "SHDistrictModel.h"

@implementation SHDistrictModel


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


+ (NSMutableArray<SHDistrictModel *> *) createTestDistictModelData;
{
    NSString * file = [[NSBundle mainBundle] pathForResource:@"区.info" ofType:nil];
    NSData * data = [NSData dataWithContentsOfFile:file];
    NSDictionary *dic = [self dictionaryWithJsonData:data];
    NSMutableArray *modelArray = [SHDistrictModel mj_objectArrayWithKeyValuesArray:dic];

    return modelArray;
}



@end
