//
//  SHMultilevelTableView.h
//  SHMultilevelTable
//
//  Created by Sam on 15/12/19.
//  Copyright © 2015年 Sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHMultilevelNodePath.h"

@class SHMultilevelTableView;

@protocol SHMutilevelTableViewDelegate <NSObject>

@optional

//tableView 又多少个sections
- (NSInteger)numberOfSectionsInMutilevelTableView:(SHMultilevelTableView *)tableView;

//每个section有多少个根节点。
- (NSInteger)mutilevelTableView:(SHMultilevelTableView *)tableView numberOfRowsInSection:(NSInteger)section;

//每个节点下有多少个子节点（不包含子孙节点数），返回0时表示没有子节点，不可以再展开
- (NSInteger)mutilevelTableView:(SHMultilevelTableView *)tableView numberOfRowsInNodePath:(SHMultilevelNodePath *)nodePath;

//当前节点需要显示的cell高度
- (CGFloat) mutilevelTableView:(SHMultilevelTableView *)tableView heightForRowAtNodePath:(SHMultilevelNodePath *)nodePath;

//根据节点路径返回相对应cell
- (UITableViewCell*)mutilevelTableView:(SHMultilevelTableView *)tableView cellForRowAtNodePath:(SHMultilevelNodePath *)nodePath;

//点击某个节点
- (void)mutilevelTableView:(SHMultilevelTableView *)tableView didSelectRowAtIndexPath:(SHMultilevelNodePath *)nodePath openNode:(BOOL *) openNode;

//替换一些UITableView 常用的代理
- (UITableViewRowAnimation)mutilevelTableView:(SHMultilevelTableView *)tableView animationOpenNode:(SHMultilevelNodePath *)nodePath;

- (UITableViewRowAnimation)mutilevelTableView:(SHMultilevelTableView *)tableView animationDeleteNode:(SHMultilevelNodePath *)nodePath;

- (BOOL)mutilevelTableView:(SHMultilevelTableView *)tableView canEditRowAtNodePath:(SHMultilevelNodePath *)nodePath;

- (void)mutilevelTableView:(SHMultilevelTableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtNodePath:(SHMultilevelNodePath *)nodePath;

- (BOOL)mutilevelTableView:(SHMultilevelTableView *)tableView canMoveRowAtNodePath:(SHMultilevelNodePath *)nodePath;

- (UITableViewCellEditingStyle)mutilevelTableView:(SHMultilevelTableView *)tableView
                    editingStyleForRowAtNodePath:(SHMultilevelNodePath *)nodePath;

- (void)mutilevelTableView:(SHMultilevelTableView *)tableView moveRowAtNodePath:(SHMultilevelNodePath *)
sourceNodPath toIndexPath:(SHMultilevelNodePath *)destinationNodePath;


@end

@interface SHMultilevelTableView : UIView

//用来内部显示的tableView
@property (nonatomic,strong) UITableView *tableView;

//数据代理
@property (nonatomic,weak) id<SHMutilevelTableViewDelegate> delegate;

//存放已经展开的节点
@property (nonatomic,readonly) NSMutableSet *openNodePathSet;

//获取节点自己在当前table中的位置
- (NSIndexPath *) indexPathForNodePath:(SHMultilevelNodePath *)nodePath;

//将tableview 的indexPath 转化为有层次关系的nodePath
- (SHMultilevelNodePath *) conversionToNodePathWithIndexPath:(NSIndexPath *)indexPath;


//实现一些UItableView的常用功能
- (void)insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation;

- (void)deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation;

- (void)reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation;

- (void)moveSection:(NSInteger)section toSection:(NSInteger)newSection;

- (void)insertRowsAtNodePaths:(NSArray<SHMultilevelNodePath *> *)nodePaths withRowAnimation:(UITableViewRowAnimation)animation insertDataSorceBlock:(void (^)()) block;

- (void)deleteRowsAtNodePaths:(NSArray<SHMultilevelNodePath *> *)nodePaths withRowAnimation:(UITableViewRowAnimation)animation  deleteDataSorceBlock:(void (^)()) block;

- (void)reloadRowsAtNodePaths:(NSArray<SHMultilevelNodePath *> *)nodePaths withRowAnimation:(UITableViewRowAnimation)animation;

- (void)moveRowAtNodePath:(SHMultilevelNodePath *)nodePath toNodePath:(SHMultilevelNodePath *)newNodePath moveDataSorceBlock:(void (^)()) block;

@end
