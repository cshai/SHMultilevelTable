//
//  SHTextOneModel.h
//  SHMultilevelTable
//
//  Created by Sam on 15/12/26.
//  Copyright © 2015年 Sam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHTextOneModel : NSObject

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSMutableArray<SHTextOneModel *> *array;

@end
