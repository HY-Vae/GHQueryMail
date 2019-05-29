//
//  IOHistoryViewController.m
//  GHQueryMail
//
//  Created by zhaozhiwei on 2019/4/23.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import "IOHistoryViewController.h"
#import "IOHistoryCell.h"
#import "Header.h"
#import "IOMailManager.h"
#import "IOMailModel.h"
#import "IOMaiDetailsViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface IOHistoryViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) UIButton *sure;

@end

@implementation IOHistoryViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.emptyDataSetDelegate = [[IOMailManager share] getAllRecords].count >  0 ?nil:self;
    self.tableView.emptyDataSetSource = [[IOMailManager share] getAllRecords].count >  0 ?nil:self;
    [self.tableView reloadData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.navigationItem.title = @"历史记录";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *sure = [[UIButton alloc]init];
    [sure setTitle:@"删除所有历史记录" forState:UIControlStateNormal];
    [sure setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [sure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sure.backgroundColor = RGBCOLOR(85, 150, 229);
    sure.layer.masksToBounds = YES;
    sure.layer.cornerRadius = 8;
    [sure addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    sure.frame = CGRectMake(10,kScreenHeight - kTabBarHeight - 50 - 10,kScreenWidth  - 20 , 50);
    sure.hidden = [IOMailManager share].getAllRecords.count >  0 ?NO:YES;
    self.sure = sure;
    [self.view addSubview:sure];
    
    
}

- (void)clickButton: (UIButton *)button {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定删除记录无法恢复" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0) {
    
    if (buttonIndex ==0) {
        [[IOMailManager share] deleteAllRecord];
        self.sure.hidden = YES;
        self.tableView.emptyDataSetDelegate = self;
        self.tableView.emptyDataSetSource = self;
        [self.tableView reloadData];

    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    IOMailModel *mailModel = [IOMailManager share].getAllRecords [indexPath.row];
    IOMaiDetailsViewController *vc = [[IOMaiDetailsViewController alloc]init];
    vc.num = mailModel.number;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [IOMailManager share].getAllRecords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IOMailModel *mailModel = [IOMailManager share].getAllRecords [indexPath.row];
    IOHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IOHistoryCellID"];
    cell.mailModel = mailModel;
    return cell;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kTabBarHeight - 70 ) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[IOHistoryCell class] forCellReuseIdentifier:@"IOHistoryCellID"];
    }
    return _tableView;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *tip = @"暂无历史记录";
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:tip attributes:nil];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, tip.length)];
    
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, tip.length)];
    return attStr;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"common_empty"];
}

@end
