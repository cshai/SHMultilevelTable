//
//  SHTextOneModel.m
//  SHMultilevelTable
//
//  Created by Sam on 15/12/26.
//  Copyright © 2015年 Sam. All rights reserved.
//

#import "SHTextOneModel.h"

@implementation SHTextOneModel


- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        _name = name;
    }
    return self;
}

- (NSMutableArray<SHTextOneModel *> *)array
{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}



@end
