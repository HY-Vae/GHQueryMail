//
//  IOMaiDetailsViewController.m
//  GHQueryMail
//
//  Created by zhaozhiwei on 2019/4/23.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import "IOMaiDetailsViewController.h"
#import "Header.h"
#import "GHHTTPManager.h"
#import "MJExtension.h"
#import "IOMailModel.h"
#import "UIImageView+WebCache.h"
#import "IOMaiDetailsCell.h"
#import "IOMaiDetailsModel.h"
#import "GHHTTPManager.h"

@interface IOMaiDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) UIView *backGround ;
@property (nonatomic , strong) IOMailModel *mailModel ;
@property (nonatomic , strong) UIImageView *imageView;
@property (nonatomic , strong) UILabel *name ;
@property (nonatomic , strong) UILabel *numL;
@property (nonatomic , strong) UIButton *phone;

@end

@implementation IOMaiDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"快递详情";

    self.view.backgroundColor = [UIColor whiteColor];
    UIView *backGround = [[UIView alloc]init];
    backGround.backgroundColor = [UIColor orangeColor];
    backGround.frame = CGRectMake(0 , kSafeAreaTopHeight, kScreenWidth, 100);
    [self.view addSubview:backGround];
    self.backGround = backGround;
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(10, 10, 80, 80);
    imageView.backgroundColor = [UIColor whiteColor];
    [backGround addSubview:imageView];
    self.imageView = imageView;
    UILabel *name = [[UILabel alloc]init];
    name.textColor = [UIColor whiteColor];
    name.frame = CGRectMake(CGRectGetMaxX(imageView.frame) + 10, 10, 200, 44);
    [backGround addSubview:name];
    self.name = name;
    
    UILabel *num = [[UILabel alloc]init];
    num.textColor = [UIColor whiteColor];
    num.frame = CGRectMake(CGRectGetMaxX(imageView.frame) + 10, CGRectGetMaxY(imageView.frame)- 30, 200, 44);
    num.text = self.num;
    [backGround addSubview:num];
    self.numL = num;

    UIButton *phone = [[UIButton alloc]init];
    [phone setImage:[UIImage imageNamed:@"aui-icon-phone@2x"] forState:UIControlStateNormal];
    phone.frame = CGRectMake(backGround.frame.size.width - 50 - 20 , 10, 50, 50);
    [phone addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [backGround addSubview:phone];
    
    [self.view addSubview:self.tableView];
    [self loadData];
}

- (void)clickButton: (UIButton *)button {
    [self callupWithNum:self.mailModel.expPhone];
}

- (void)callupWithNum: (NSString *)num {
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@",num];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
}
- (void)loadData {
    weakself(self);
    [[GHHTTPManager sharedManager] queryMailWithNum:self.num finishedBlock:^(id responseObject, NSError *error) {
        
        NSDictionary *result = responseObject[@"result"];
        NSMutableArray *listArr = [NSMutableArray array];
        NSArray *list = result[@"list"];
        for (NSDictionary *dict in list) {
            IOMaiDetailsModel *maiDetailsModel = [IOMaiDetailsModel mj_objectWithKeyValues:dict];
            [listArr addObject:maiDetailsModel];
        }
        IOMailModel *mailModel = [IOMailModel mj_objectWithKeyValues:result];
        mailModel.list = listArr.copy;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.imageView sd_setImageWithURL:[NSURL URLWithString:mailModel.logo] placeholderImage:[UIImage imageNamed:@"empty"]];

            weakSelf.name.text = mailModel.expName;
            weakSelf.mailModel = mailModel;
            [weakSelf.tableView reloadData];
        });
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mailModel.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IOMaiDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IOMaiDetailsCellID"];
    IOMaiDetailsModel *maiDetailsModel = self.mailModel.list[indexPath.row];
    maiDetailsModel.indexPath = indexPath;
    cell.maiDetailsModel = maiDetailsModel;
    if (indexPath.row == self.mailModel.list.count - 1) {
        [cell setLineStatusHidden];
    } else {
        [cell setLineStatusShow];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.backGround.frame), kScreenWidth, kScreenHeight - kSafeAreaTopHeight -self.backGround.frame.size.height - kSafeAreaBottomHeight - kStatusBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[IOMaiDetailsCell class] forCellReuseIdentifier:@"IOMaiDetailsCellID"];
    }
    return _tableView;
}

- (IOMailModel *)mailModel {
    if (_mailModel == nil) {
        _mailModel = [[IOMailModel alloc]init];
    }
    return _mailModel;
}


@end
