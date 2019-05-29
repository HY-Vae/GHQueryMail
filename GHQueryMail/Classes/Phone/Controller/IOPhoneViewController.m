//
//  IOPhoneViewController.m
//  GHQueryMail
//
//  Created by zhaozhiwei on 2019/4/23.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import "IOPhoneViewController.h"
#import "IOPhoneCell.h"
#import "Header.h"
#import "IOPhoneModel.h"

@interface IOPhoneViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) NSArray *dataArray;
@property (nonatomic , strong) UIButton *deleted;

@end

@implementation IOPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.navigationItem.title = @"常用快递电话";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self loadData];
}

- (void)loadData {
    IOPhoneModel *phoneModel = [[IOPhoneModel alloc]init];
    self.dataArray = [phoneModel getData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IOPhoneModel *phoneModel = self.dataArray[indexPath.row];;
    IOPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IOPhoneCellID"];
    cell.phoneModel = phoneModel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    IOPhoneModel *phoneModel = self.dataArray[indexPath.row];;
    [self callupWithNum:phoneModel.phone];
}

- (void)callupWithNum: (NSString *)num {
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@",num];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
}
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kSafeAreaTopHeight, kScreenWidth, kScreenHeight - kSafeAreaTopHeight - kTabBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[IOPhoneCell class] forCellReuseIdentifier:@"IOPhoneCellID"];
    }
    return _tableView;
}


@end
