# SHMultilevelTable
使用SHMultiLeveTable 可以让你非常容易的实现cell的分层展开，并且不限展开层数，你可以根据数据模型自由控制展开的层数，分层从未如此简单。

## 导入方法
将文件夹SHMultiLevelTable下面6个文件拷贝到你的工程
<br>
SHMultilevelNodePath.h
        SHMultilevelNodePath.m
        SHMultilevelTableView.h
        SHMultilevelTableView.m
        SHMultilevelTableViewController.h
        SHMultilevelTableViewController.m

### SHMultilevelTableView使用方法
        如果你的项目中使用UITableView，具体实现方法可以参考SHTestOneView，SHTestTwoView，SHTestThreeView 这三个示例
        第1步 将SHMultilevelTableView作为你的tableView的父类。
        第2步 在你的控制器中实现SHMutilevelTableViewDelegate协议。
        第3步 实现SHMutilevelTableViewDelegate协议。

### SHMultilevelTableViewController使用方法
如果你的项目中使用UITableViewController，具体实现方法可以参考SHTestFourViewController示例
<br>
1 将SHMultilevelTableViewController作为你的tableViewcontroller的父类。
        2 在tableViewcontroller中实现SHMutilevelTableViewControllerDelegate协议。

<br>
## 下面是简单的演示
<br>
![pic1](https://github.com/cshai/SHMultilevelTable/blob/master/other/pic1.gif)
<br>



