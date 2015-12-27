//
//  SHBaseTableViewCell.m
//  SHMultilevelTable
//
//  Created by Sam on 15/12/20.
//  Copyright © 2015年 Sam. All rights reserved.
//

#import "SHBaseTableViewCell.h"

@interface SHBaseTableViewCell ()


@end


@implementation SHBaseTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    selected = NO;
    
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
