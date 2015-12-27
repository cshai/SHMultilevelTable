//
//  SHMultilevelTableViewController.m
//  SHMultilevelTable
//
//  Created by Sam on 15/12/27.
//  Copyright © 2015年 Sam. All rights reserved.
//

#import "SHMultilevelTableViewController.h"

@interface SHMultilevelTableViewController ()

@end

@implementation SHMultilevelTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _openNodePathSet = [NSMutableSet set];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ( [self respondsToSelector:@selector(numberOfSectionsInMutilevelTableView:)] ){
        return [self numberOfSectionsInMutilevelTableView:tableView];
    }
    return 1;
}

// 获取某个节点下面所有已经展开的节点数目
- (NSInteger) totalNumberOfRowsInNodePath:(SHMultilevelNodePath *) nodePath
{
    //表示节点有子节点，但未展开
    if (![self.openNodePathSet containsObject:nodePath])
        return 1;
    
    NSInteger totalNum = 1;
    NSInteger indexPathNum = 0;
    
    //获取子节点数
    if ([self respondsToSelector:@selector(mutilevelTableView:numberOfRowsInNodePath:)])
        indexPathNum = [self mutilevelTableView:self.tableView numberOfRowsInNodePath:nodePath];
    
    //遍历获取每个子节点展开的节点数目
    for (int i = 0; i < indexPathNum; i++) {
        SHMultilevelNodePath * subNodePath = [nodePath subNodePathWithSubIndex:i];
        totalNum += [self totalNumberOfRowsInNodePath:subNodePath];
    }
    
    return totalNum;
};

//获取某个section下面所有已经展开的节点数目
- (NSInteger) totalNumberOfRowsInSection:(NSInteger) section{
    NSInteger sectionNum = 0;
    
    // 获取section下的子节点数，不包含孙节点
    if ([self respondsToSelector:@selector(mutilevelTableView:numberOfRowsInSection:)])
        sectionNum = [self mutilevelTableView:self.tableView numberOfRowsInSection:section];
    
    NSInteger currentTotalNodeNum = 0;
    
    //遍历每个子节点，获取每个子节点已经展开的节点数目
    for (int i = 0; i < sectionNum; i++ ) {
        SHMultilevelNodePath * nodePath = [SHMultilevelNodePath nodePathWithPath:[NSArray arrayWithObject:@(i)] section:section];
        currentTotalNodeNum += [self totalNumberOfRowsInNodePath:nodePath];
    }
    return currentTotalNodeNum;
};

//以nodePath节点所处的位置作为根节点，序号0，查找序号为row时对应的显示的时哪个子孙节点
- (SHMultilevelNodePath *) subNodeWithRootMutilevelNodePath:(SHMultilevelNodePath *)nodePath row:(NSInteger) row
{
    if (row == 0) {
        //要找的就是根节点，无需展开该节点遍历
        return nodePath;
    }
    
    if (![self.openNodePathSet containsObject:nodePath])
    {
        //nodePath节点未展开，证明还是只显示一行，既row只能为0 ，其他相当于找不到
        return nil;
    }
    
    //本身不是要找的节点，需要遍历子节点查找
    
    //这里存储已经遍历了多少行，已经遍历过row = 0的情况，这里初始化为1
    NSInteger currentFindedRowNum = 1;
    
    NSInteger subNodeNum  = 0;
    if ([self respondsToSelector:@selector(mutilevelTableView:numberOfRowsInNodePath:)])
        subNodeNum = [self  mutilevelTableView:self.tableView numberOfRowsInNodePath:nodePath];
    
    for (int i = 0; i < subNodeNum; i++ ) {
        
        NSInteger currentNum = 0;
        
        SHMultilevelNodePath * subNodePath = [nodePath subNodePathWithSubIndex:i];
        
        //获取子节点的节点个数
        currentNum = [self totalNumberOfRowsInNodePath:subNodePath];
        if (currentFindedRowNum + currentNum <= row) {
            //找到的节点行数还没到要找row
            currentFindedRowNum += currentNum;
            continue;
        }else{
            //表示遍历到当前节点时，已经刚超过了row节点数，目标在这个节点或者在这个节点的子节点上，这里递归查找子节点
            return [self subNodeWithRootMutilevelNodePath:subNodePath row:row - currentFindedRowNum];
        }
    }
    //表示在子节点中也无法找到
    return nil;
}

//将tableview 的indexPath 转化为有层次关系的nodePath
- (SHMultilevelNodePath *) conversionToNodePathWithIndexPath:(NSIndexPath *)indexPath
{
    NSInteger currentFindedRowNum = 0;
    NSInteger sectionNum = 0;
    
    //获取当前section又多少个根节点
    if ([self respondsToSelector:@selector(mutilevelTableView:numberOfRowsInSection:)])
        sectionNum = [self  mutilevelTableView:self.tableView numberOfRowsInSection:indexPath.section];
    
    //从第一个根节点开始遍历，直到找到刚好对应indexPath.row对应的位置
    for (int i = 0; i < sectionNum; i++ ) {
        
        NSInteger currentNodeNum = 0;
        
        SHMultilevelNodePath * nodePath = [SHMultilevelNodePath nodePathWithPath:[NSArray arrayWithObject:@(i)] section:indexPath.section];
        
        //获取这个节点下所有展开的节点
        currentNodeNum = [self totalNumberOfRowsInNodePath:nodePath];
        if (currentFindedRowNum + currentNodeNum  <= indexPath.row) {
            //目标不在这个节点及它的所有子节点上，还未到达要查找的行
            currentFindedRowNum += currentNodeNum;
        }else{
            //需要查找的目标在当前节点或者它的子节点上，递归继续查找
            return [self subNodeWithRootMutilevelNodePath:nodePath row:indexPath.row - currentFindedRowNum];
        }
    }
    return nil;
}

//获取节点在父节点中的显示位置，（既离它的父节点的行数）
- (NSInteger)numberOfParentNodePath:(SHMultilevelNodePath *)nodePath {
    NSInteger num = 0;
    if (nodePath.path.count == 0) {
        return 0;
    }
    //遍历在自己前面，并且等级相同的节点已经该节点的子节点个数。
    int indexOfCurrentLevel = [nodePath.path.lastObject intValue];
    
    SHMultilevelNodePath *parentNodePath = [nodePath superNodePathWithRange:NSMakeRange(0, nodePath.path.count - 1)];
    for (int i = 0; i < indexOfCurrentLevel; i++) {
        SHMultilevelNodePath *frontNodePath = [parentNodePath subNodePathWithSubIndex:i];
        num += [self totalNumberOfRowsInNodePath:frontNodePath];
    }
    //自己本身也是一个节点
    num += 1;
    return num;
};


//在一个section中，获取某一节点显示的位置
- (NSInteger)numberOfNodePathInSection:(SHMultilevelNodePath *)nodePath {
    NSInteger num = 0;
    
    for (int i = 0; i < nodePath.path.count; i++) {
        //分别计算每一个级前面有多少个节点
        SHMultilevelNodePath *frontNodePathLevel = [nodePath superNodePathWithRange:NSMakeRange(0, i + 1)];
        num += [self numberOfParentNodePath:frontNodePathLevel];
    }
    return num;
};

//获取节点自己在当前table中的位置
- (NSIndexPath *) indexPathForNodePath:(SHMultilevelNodePath *)nodePath
{
    NSInteger nodePathNum = 0;
    
    nodePathNum = [self numberOfNodePathInSection:nodePath];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:nodePathNum - 1 inSection:nodePath.section];
    
    return indexPath;
}

//获取节点以及所有已近展开的的子节点，在当前占有的行位置。
- (NSMutableArray<NSIndexPath *> *)indexPathArrayForNodePath:(SHMultilevelNodePath *)nodePath
{
    NSMutableArray<NSIndexPath *> *indexPathList = [[NSMutableArray alloc] init];
    NSInteger rowNum = [self totalNumberOfRowsInNodePath:nodePath];
    NSIndexPath *rootIndexPath = [self indexPathForNodePath:nodePath];
    
    for (NSInteger i = 0; i < rowNum; i++) {
        NSInteger row = rootIndexPath.row + i;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:nodePath.section];
        [indexPathList addObject:indexPath];
    }
    return indexPathList;
};

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //返回section下的所有节点数）
    return [self totalNumberOfRowsInSection:section];
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHMultilevelNodePath * nodePath = [self conversionToNodePathWithIndexPath:indexPath];
    
    if ([self respondsToSelector:@selector(mutilevelTableView:heightForRowAtNodePath:)])
        return  [self mutilevelTableView:self.tableView heightForRowAtNodePath:nodePath];
    
    return 50.0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHMultilevelNodePath * nodePath = [self conversionToNodePathWithIndexPath:indexPath];
    UITableViewCell * cell = nil;
    if ([self respondsToSelector:@selector(mutilevelTableView:cellForRowAtNodePath:)])
        cell = [self mutilevelTableView:self.tableView cellForRowAtNodePath:nodePath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SHTableViewCellStyleDefault"];
    }
    return cell;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHMultilevelNodePath * nodePath = [self conversionToNodePathWithIndexPath:indexPath];
    BOOL isOpeningNode = [self.openNodePathSet containsObject:nodePath];
    BOOL needOpenNode = !isOpeningNode;
    if ([self respondsToSelector:@selector(mutilevelTableView:didSelectRowAtIndexPath:openNode:)])
        [self mutilevelTableView:self.tableView didSelectRowAtIndexPath:nodePath openNode:&needOpenNode];
    
    // 无需展开或者关闭节点
    if (needOpenNode == isOpeningNode)
        return;
    
    if (needOpenNode)
    {
        if ([self mutilevelTableView:self.tableView numberOfRowsInNodePath:nodePath] > 0) {
            //可以被展开
            [self.openNodePathSet addObject:nodePath];
            UITableViewRowAnimation rowAnimation = UITableViewRowAnimationNone;
            if ([self respondsToSelector:@selector(mutilevelTableView:animationOpenNode:)])
                rowAnimation = [self mutilevelTableView:self.tableView animationOpenNode:nodePath];
            NSMutableArray<NSIndexPath *> *indexPathList = [self indexPathArrayForNodePath:nodePath];
            //移除自己本身
            [indexPathList removeObjectAtIndex:0];
            
            [self.tableView insertRowsAtIndexPaths:indexPathList withRowAnimation:rowAnimation];
        }
    }else
    {
        UITableViewRowAnimation rowAnimation = UITableViewRowAnimationNone;
        if ([self respondsToSelector:@selector(mutilevelTableView:animationDeleteNode:)])
            rowAnimation = [self mutilevelTableView:self.tableView animationDeleteNode:nodePath];
        NSMutableArray<NSIndexPath *> *indexPathList = [self indexPathArrayForNodePath:nodePath];
        //移除自己本身
        [indexPathList removeObjectAtIndex:0];
        
        [self.openNodePathSet removeObject:nodePath];
        [self.tableView deleteRowsAtIndexPaths:indexPathList withRowAnimation:rowAnimation];
    }
}

- (void)insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    [self.tableView insertSections:sections withRowAnimation:animation];
}

- (void)deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    [self.tableView deleteSections:sections withRowAnimation:animation];
}

- (void)reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    [self.tableView reloadSections:sections withRowAnimation:animation];
}

- (void)moveSection:(NSInteger)section toSection:(NSInteger)newSection
{
    [self.tableView moveSection:section toSection:newSection];
}

- (void)insertRowsAtNodePaths:(NSArray<SHMultilevelNodePath *> *)nodePaths withRowAnimation:(UITableViewRowAnimation)animation insertDataSorceBlock:(void (^)()) block
{
    NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray array];
    if (block) {
        //先插入数据，否则后面无法计算插入的位置
        block();
    }
    [nodePaths enumerateObjectsUsingBlock:^(SHMultilevelNodePath * _Nonnull nodePath, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray<NSIndexPath *> *indexPathList = [self indexPathArrayForNodePath:nodePath];
        [indexPaths addObjectsFromArray:indexPathList];
    }];
    
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    
}

- (void)deleteRowsAtNodePaths:(NSArray<SHMultilevelNodePath *> *)nodePaths withRowAnimation:(UITableViewRowAnimation)animation  deleteDataSorceBlock:(void (^)()) block
{
    NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray array];
    
    //先计算位置
    [nodePaths enumerateObjectsUsingBlock:^(SHMultilevelNodePath * _Nonnull nodePath, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray<NSIndexPath *> *indexPathList = [self indexPathArrayForNodePath:nodePath];
        [indexPaths addObjectsFromArray:indexPathList];
    }];
    //在删除数据
    if (block) {
        block();
    }
    [nodePaths enumerateObjectsUsingBlock:^(SHMultilevelNodePath * _Nonnull nodePath, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.openNodePathSet removeObject:nodePath];
    }];
    
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}


- (void)reloadRowsAtNodePaths:(NSArray<SHMultilevelNodePath *> *)nodePaths withRowAnimation:(UITableViewRowAnimation)animation {
    
    NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray array];
    
    [nodePaths enumerateObjectsUsingBlock:^(SHMultilevelNodePath * _Nonnull nodePath, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray<NSIndexPath *> *indexPathList = [self indexPathArrayForNodePath:nodePath];
        [indexPaths addObjectsFromArray:indexPathList];
        
    }];
    
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)moveRowAtNodePath:(SHMultilevelNodePath *)nodePath toNodePath:(SHMultilevelNodePath *)newNodePath  moveDataSorceBlock:(void (^)()) block
{
    //先计算旧位置
    NSIndexPath * indexPath = [self indexPathForNodePath:nodePath];
    //重新计算新位置
    NSIndexPath * newIndexPath = [self indexPathForNodePath:newNodePath];
    
    //更新数据源
    if (block) {
        block();
    }
    //执行移动
    [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    SHMultilevelNodePath * nodePath = [self conversionToNodePathWithIndexPath:indexPath];
    if ([self respondsToSelector:@selector(mutilevelTableView:canEditRowAtNodePath:)]) {
        return [self mutilevelTableView:self.tableView canEditRowAtNodePath:nodePath];
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SHMultilevelNodePath * nodePath = [self conversionToNodePathWithIndexPath:indexPath];
    
    if ([self respondsToSelector:@selector(mutilevelTableView:commitEditingStyle:forRowAtNodePath:)]) {
        [self mutilevelTableView:self.tableView commitEditingStyle:editingStyle forRowAtNodePath:nodePath];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    SHMultilevelNodePath * nodePath = [self conversionToNodePathWithIndexPath:indexPath];
    if ([self respondsToSelector:@selector(mutilevelTableView:canMoveRowAtNodePath:)]) {
        return [self mutilevelTableView:self.tableView canMoveRowAtNodePath:nodePath];
    }
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SHMultilevelNodePath * nodePath = [self conversionToNodePathWithIndexPath:indexPath];
    
    if ([self respondsToSelector:@selector(mutilevelTableView:editingStyleForRowAtNodePath:)]) {
        return [self mutilevelTableView:self.tableView editingStyleForRowAtNodePath:nodePath];
    }
    
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)
sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    SHMultilevelNodePath * sourceNodePath = [self conversionToNodePathWithIndexPath:sourceIndexPath];
    SHMultilevelNodePath * destinationNodePath = [self conversionToNodePathWithIndexPath:destinationIndexPath];
    if ([self respondsToSelector:@selector(mutilevelTableView:moveRowAtNodePath:toIndexPath:)]) {
        [self mutilevelTableView:self.tableView moveRowAtNodePath:sourceNodePath toIndexPath:destinationNodePath];
    }
}

@end
