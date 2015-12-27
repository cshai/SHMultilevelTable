//
//  SHMainTestViewController.m
//  SHMultilevelTable
//
//  Created by Sam on 15/12/26.
//  Copyright © 2015年 Sam. All rights reserved.
//

#import "SHMainTestViewController.h"
#import "SHTestOneView.h"
#import "SHTestTwoView.h"
#import "SHTestThreeView.h"
#import "SHTestFourViewController.h"


@interface SHMainTestViewController ()


@property (weak, nonatomic) IBOutlet UIView *tableContentView;

@property (nonatomic,strong) SHTestOneView * oneView;

@property (nonatomic,strong) SHTestTwoView *twoView;

@property (nonatomic,strong) SHTestThreeView *threeView;

@property (nonatomic,strong) SHTestFourViewController *fourViewController;

@end

@implementation SHMainTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.oneView.backgroundColor = [UIColor whiteColor];
    self.twoView.backgroundColor = [UIColor whiteColor];
    self.threeView.backgroundColor = [UIColor whiteColor];
    self.fourViewController.view.backgroundColor = [UIColor whiteColor];
}

- (void) viewDidAppear:(BOOL)animated
{
    self.oneView.frame = self.tableContentView.bounds;
    self.twoView.frame = self.tableContentView.bounds;
    self.threeView.frame = self.tableContentView.bounds;
    self.fourViewController.view.frame = self.tableContentView.bounds;
    [super viewDidAppear:animated];
}


- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            [self.tableContentView addSubview:self.oneView];
            [self.twoView removeFromSuperview];
            [self.threeView removeFromSuperview];
            [self.fourViewController.view removeFromSuperview];
        }break;
        case 1:
        {
            [self.tableContentView addSubview:self.twoView];
            [self.oneView removeFromSuperview];
            [self.threeView removeFromSuperview];
            [self.fourViewController.view removeFromSuperview];

        }break;
        case 2:
        {
            [self.tableContentView addSubview:self.threeView];
            [self.oneView removeFromSuperview];
            [self.twoView removeFromSuperview];
            [self.fourViewController.view removeFromSuperview];

        }break;
        case 3:
        {
            [self.tableContentView addSubview:self.fourViewController.view];
            [self.oneView removeFromSuperview];
            [self.twoView removeFromSuperview];
            [self.threeView removeFromSuperview];
            
        }break;
     
        default:
            break;
    }
}

- (SHTestOneView *) oneView
{
    if (!_oneView) {
        _oneView = [[SHTestOneView alloc] init];
        self.oneView.frame = self.tableContentView.bounds;
        [self.tableContentView addSubview:self.oneView];
    }
    return _oneView;
}

- (SHTestTwoView *)twoView
{
    if (!_twoView) {
        _twoView = [[SHTestTwoView alloc] init];
    }
    return _twoView;
}

- (SHTestThreeView *)threeView
{
    if (!_threeView) {
        _threeView = [[SHTestThreeView alloc] init];
    }
    return _threeView;
}

- (SHTestFourViewController *)fourViewController
{
    if (!_fourViewController) {
        _fourViewController = [[SHTestFourViewController alloc] init];
    }
    return _fourViewController;
}

@end
