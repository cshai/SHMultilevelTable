//
//  SHMultilevelNodePath.m
//  SHMultilevelTable
//
//  Created by Sam on 15/12/20.
//  Copyright © 2015年 Sam. All rights reserved.
//

#import "SHMultilevelNodePath.h"

@interface SHMultilevelNodePath ()

@end

@implementation SHMultilevelNodePath

- (instancetype)initWithPath:(NSArray<NSNumber *> *)path section:(NSInteger)section
{
    self = [super init];
    if (self) {
        _path = [path mutableCopy];
        _section = section;
    }
    return self;
}

+ (instancetype)nodePathWithPath:(NSArray<NSNumber *> *)path section:(NSInteger)section;
{
    SHMultilevelNodePath *nodePath = [[SHMultilevelNodePath alloc] initWithPath:path section:section];
    return nodePath;
}

- (instancetype)superNodePathWithRange:(NSRange)range
{
    SHMultilevelNodePath *nodePath = [[SHMultilevelNodePath alloc] initWithPath:[self.path subarrayWithRange:range] section:self.section];
    return nodePath;
};

- (instancetype)subNodePathWithSubIndex:(NSInteger)index
{
    NSMutableArray *subPath = [NSMutableArray arrayWithArray:self.path];
    [subPath addObject:@(index)];
    SHMultilevelNodePath *subNodePath = [[SHMultilevelNodePath alloc] initWithPath:subPath section:self.section];
    return subNodePath;
    
}

- (NSString *)description
{
    NSMutableString * str = [[NSMutableString alloc] init];
    [str appendFormat:@"section:%zd path",self.section];
    [self.path enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [str appendFormat:@":%zd",[obj integerValue]];
    }];
    return str;
}

- (BOOL) isEqual:(SHMultilevelNodePath *)object
{
    if (object.section != self.section) {
        return NO;
    }
    if (object.path.count != self.path.count) {
        return NO;
    }
    for (int i = 0; i < self.path.count; i++) {
        if ([self.path[i] integerValue ] != [object.path[i] integerValue]) {
            return NO;
        }
    }
    return YES;
    //return object.hash == self.hash;
}

- (NSUInteger)hash
{
    return (NSUInteger)self.description.hash;
}

@end

