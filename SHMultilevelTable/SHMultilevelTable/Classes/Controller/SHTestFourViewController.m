//
//  SHTestFourViewController.m
//  SHMultilevelTable
//
//  Created by Sam on 15/12/27.
//  Copyright © 2015年 Sam. All rights reserved.
//

#import "SHTestFourViewController.h"
#import "SHMultilevelTableView.h"
#import "SHBaseTableViewCell.h"
#import "SHProvinceModel.h"


static NSString *kCellID = @"SHBaseTableViewCell";


@interface SHTestFourViewController ()

@property (nonatomic,strong) NSMutableArray <SHProvinceModel *> *provinceModelArray;

@end

@implementation SHTestFourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.provinceModelArray =  [SHProvinceModel createTestProvinceModelData];
}


- (NSInteger)numberOfSectionsInMutilevelTableView:(UITableView *)tableView
{
    return 1;
}

//表示在section中有多少个
- (NSInteger)mutilevelTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.provinceModelArray.count;
}

- (NSInteger)mutilevelTableView:(UITableView *)tableView numberOfRowsInNodePath:(SHMultilevelNodePath *)nodePath{
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

- (CGFloat)mutilevelTableView:(UITableView *)tableView heightForRowAtNodePath:(SHMultilevelNodePath *)nodePath{
    return 40.0;
}

- (UITableViewCell* )mutilevelTableView:(UITableView *)tableView cellForRowAtNodePath:(SHMultilevelNodePath *)nodePath{
    
    SHBaseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
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

@end
