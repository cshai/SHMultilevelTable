//
//  SHMultilevelNodePath.h
//  SHMultilevelTable
//
//  Created by Sam on 15/12/20.
//  Copyright © 2015年 Sam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHMultilevelNodePath : NSObject

// tableView 的Section
@property (nonatomic,assign,readonly) NSInteger section;

// 多级节点路径，数组元素个数代表节点层次，数组元素越多，层次越深
@property (nonatomic,copy,readonly) NSArray<NSNumber *> *path;

+ (instancetype)nodePathWithPath:(NSArray<NSNumber *> *)path section:(NSInteger)section;

- (instancetype)superNodePathWithRange:(NSRange)range;

- (instancetype)subNodePathWithSubIndex:(NSInteger) index;


@end
