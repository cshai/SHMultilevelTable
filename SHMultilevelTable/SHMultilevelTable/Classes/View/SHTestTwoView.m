//
//  SHTestTwoView.m
//  SHMultilevelTable
//
//  Created by Sam on 15/12/26.
//  Copyright © 2015年 Sam. All rights reserved.
//

#import "SHTestTwoView.h"

#import "SHMultilevelTableView.h"
#import "SHBaseTableViewCell.h"
#import "SHProvinceModel.h"


static NSString *kCellID = @"SHBaseTableViewCell";


@interface SHTestTwoView () <SHMutilevelTableViewDelegate>

@property (nonatomic,strong) SHMultilevelTableView *tabelView;

@property (nonatomic,strong) NSMutableArray <SHProvinceModel *> *provinceModelArray;
@end


@implementation SHTestTwoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _provinceModelArray =  [SHProvinceModel createTestProvinceModelData];
        [self.tabelView.tableView reloadData];
    }
    return self;
}

- (NSInteger)numberOfSectionsInMutilevelTableView:(SHMultilevelTableView *)tableView
{
    return 1;
}

//表示在section中有多少个
- (NSInteger)mutilevelTableView:(SHMultilevelTableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.provinceModelArray.count;
}

- (NSInteger)mutilevelTableView:(SHMultilevelTableView *)tableView numberOfRowsInNodePath:(SHMultilevelNodePath *)nodePath{
    if (nodePath.path.count == 1) {
        NSInteger indexPro = [nodePath.path[0] integerValue];
        return self.provinceModelArray[indexPro].cityArray.count;
    }else if(nodePath.path.count == 2){
        NSInteger indexPro = [nodePath.path[0] integerValue];
        NSInteger indexCity = [nodePath.path[1] integerValue];
        return self.provinceModelArray[indexPro].cityArray[indexCity].districtArray.count;
    }
    return 0;
};

- (CGFloat)mutilevelTableView:(SHMultilevelTableView *)tableView heightForRowAtNodePath:(SHMultilevelNodePath *)nodePath{
    return 40.0;
}

- (UITableViewCell* )mutilevelTableView:(SHMultilevelTableView *)tableView cellForRowAtNodePath:(SHMultilevelNodePath *)nodePath{
    
    SHBaseTableViewCell * cell = [tableView.tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SHBaseTableViewCell" owner:nil options:nil] lastObject];
    }
    NSString *str = @"";
    for (int i = 0; i < nodePath.path.count - 1; i++) {
        str =  [str stringByAppendingString:@"    "];
    }
    if (nodePath.path.count == 1) {
        NSInteger indexPro = [nodePath.path[0] integerValue];
        str = [str stringByAppendingString:self.provinceModelArray[indexPro].name];
        NSLog(@"%@",str);
    }else if(nodePath.path.count == 2){
        NSInteger indexPro = [nodePath.path[0] integerValue];
        NSInteger indexCity = [nodePath.path[1] integerValue];
        str = [str stringByAppendingString:self.provinceModelArray[indexPro].cityArray[indexCity].name];
    }else if (nodePath.path.count == 3)
    {
        NSInteger indexPro = [nodePath.path[0] integerValue];
        NSInteger indexCity = [nodePath.path[1] integerValue];
        NSInteger indexDis = [nodePath.path[2] integerValue];
        str = [str stringByAppendingString:self.provinceModelArray[indexPro].cityArray[indexCity].districtArray[indexDis].DisName];
    }
    cell.infoLabel.text = str;
    return cell;
}

- (BOOL)mutilevelTableView:(SHMultilevelTableView *)tableView canEditRowAtNodePath:(SHMultilevelNodePath *)nodePath
{
    return YES;
}

- (void)mutilevelTableView:(SHMultilevelTableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtNodePath:(SHMultilevelNodePath *)nodePath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray<SHMultilevelNodePath *> *nodePaths = [NSArray arrayWithObject:nodePath];
        [tableView deleteRowsAtNodePaths:nodePaths withRowAnimation:UITableViewRowAnimationNone deleteDataSorceBlock:^{
            //先移除数据源
            if (nodePath.path.count == 1) {
                NSInteger indexPro = [nodePath.path[0] integerValue];
                [self.provinceModelArray removeObjectAtIndex:indexPro];
            }else if (nodePath.path.count == 2)
            {
                NSInteger indexPro = [nodePath.path[0] integerValue];
                NSInteger indexCity = [nodePath.path[1] integerValue];
                [self.provinceModelArray[indexPro].cityArray removeObjectAtIndex:indexCity];
            }else if (nodePath.path.count == 3)
            {
                NSInteger indexPro = [nodePath.path[0] integerValue];
                NSInteger indexCity = [nodePath.path[1] integerValue];
                NSInteger indexDis = [nodePath.path[2] integerValue];
                [self.provinceModelArray[indexPro].cityArray[indexCity].districtArray removeObjectAtIndex:indexDis];
            }
        }];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.tabelView.frame = self.bounds;
}

- (SHMultilevelTableView *) tabelView
{
    if (!_tabelView) {
        _tabelView = [[SHMultilevelTableView alloc] initWithFrame:self.frame];
        _tabelView.backgroundColor = [UIColor greenColor];
        _tabelView.delegate = self;
        [self addSubview:_tabelView];
    }
    return _tabelView;
}

@end