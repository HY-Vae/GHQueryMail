//
//  IOSendMailViewController.m
//  GHQueryMail
//
//  Created by zhaozhiwei on 2019/5/9.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import "IOSendMailViewController.h"
#import "IOSendMailCell.h"
#import "Header.h"
#import "IOSendMailHeader.h"
#import "IOPhoneViewController.h"
#import "YBPopupMenu.h"
#import "ToastTool.h"

@interface IOSendMailViewController ()<UITableViewDelegate,UITableViewDataSource,YBPopupMenuDelegate>
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) IOSendMailHeader *header;

@property (nonatomic , strong) NSArray *mailCompanys;
@property (nonatomic , copy) NSString *receiverName;
@property (nonatomic , copy) NSString *receiverPhone;
@property (nonatomic , copy) NSString *receiverAddress;
@property (nonatomic , copy) NSString *sendName;
@property (nonatomic , copy) NSString *sendPhone;
@property (nonatomic , copy) NSString *sendAddress;
@property (nonatomic , copy) NSString *mailCompany;

@end

@implementation IOSendMailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.tableView];
    self.navigationItem.title = @"自助发快递";
    self.tableView.tableHeaderView = self.header;
    
    UIButton *sendMail = [[UIButton alloc]init];
    [sendMail setTitle:@"我填好了,我要发快件" forState:UIControlStateNormal];
    [sendMail setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [sendMail setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendMail.backgroundColor = RGBCOLOR(85, 150, 229);
    sendMail.layer.masksToBounds = YES;
    sendMail.layer.cornerRadius = 8;
    [sendMail addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    sendMail.frame = CGRectMake(10,CGRectGetMaxY(self.tableView.frame) + 10,kScreenWidth  - 20, 50);
    [self.view addSubview:sendMail];
}

- (void)clickButton: (UIButton *)button {
    
    
    if (self.mailCompany.length == 0) {
        [ToastTool makeToast:@"必须选择一个快递公司" targetView:self.view];
        return;
    }
    if (self.receiverName.length == 0) {
        [ToastTool makeToast:@"收货人姓名不能为空" targetView:self.view];
        return;
    }
    if (self.receiverPhone.length == 0) {
        [ToastTool makeToast:@"收货人电话不能为空" targetView:self.view];
        return;

    }
    if (self.receiverAddress.length == 0) {
        [ToastTool makeToast:@"收货人地址不能为空" targetView:self.view];
        return;

    }
    
    if (self.sendName.length == 0) {
        [ToastTool makeToast:@"发货人姓名不能为空" targetView:self.view];
        return;

    }
    if (self.sendPhone.length == 0) {
        [ToastTool makeToast:@"发货人电话不能为空" targetView:self.view];
        return;

    }
    if (self.receiverAddress.length == 0) {
        [ToastTool makeToast:@"发货人地址不能为空" targetView:self.view];
        return;
    }
    
    [self.view endEditing:YES];
    [ToastTool makeToast:@"寄件成功" targetView:self.view];
    
    for (NSInteger i = 0; i < 2 ; i++) {
        for (NSInteger j = 0; j < 3;j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            IOSendMailCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [cell clearData];
        }
    }
    self.mailCompany = nil;
    self.receiverName = nil;
    self.receiverPhone = nil;
    self.receiverAddress = nil;
    self.sendName = nil;
    self.sendPhone = nil;
    self.sendAddress = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, kScreenWidth - 20, 44)];
    label.text = section == 0 ? @"填写收件人信息":@"填写发件人信息";
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IOSendMailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IOSendMailCellID"];
    cell.indexPath = indexPath;
    weakself(self);
    cell.inputBlock = ^(NSString * _Nonnull str, NSIndexPath * _Nonnull indexPath) {
        
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0 :
                    weakSelf.receiverName = str;
                    break;
                case 1 :
                    weakSelf.receiverPhone = str;
                    break;
                case 2 :
                    weakSelf.receiverAddress= str;
                    break;
                default:
                    break;
            }
        } else {
            switch (indexPath.row) {
                case 0 :
                    weakSelf.sendName = str;
                    break;
                case 1 :
                    weakSelf.sendPhone = str;
                    break;
                case 2 :
                    weakSelf.sendAddress = str;
                    break;
                default:
                    break;
            }
        }
            
    };
    return cell;
}

- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index {
    NSString *title = self.mailCompanys[index];
    self.header.mailCompany = title;
    self.mailCompany = title;
}

- (IOSendMailHeader *)header {
    if (_header == nil) {
        _header = [[IOSendMailHeader alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        weakself(self);
        _header.choseBlock = ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择快递公司" message:@"只有部分公司可以选择自助发快递" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancelAction];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [YBPopupMenu showRelyOnView:weakSelf.header.chose titles:weakSelf.mailCompanys icons:nil menuWidth:100 delegate:weakSelf];
            }];
            [alert addAction:confirmAction];
            [weakSelf presentViewController:alert animated:YES completion:^{

            }];
        };
    }
    return _header;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kSafeAreaTopHeight, kScreenWidth, kScreenHeight - kSafeAreaTopHeight - kTabBarHeight -70) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[IOSendMailCell class] forCellReuseIdentifier:@"IOSendMailCellID"];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}

- (NSArray *)mailCompanys {
    if (_mailCompanys == nil) {
        _mailCompanys = [NSArray arrayWithObjects:
                         @"EMS邮政特快",
                         
                         @"申通快递",
                         
                         @"圆通速递",
                         
                         @"顺丰速运",
                         
                         @"韵达快递",
                         
                         @"中通速递",
                         
                         @"海航天天快递",
                         
                         @"汇通快运",
                         
                         @"宅急送",
                         
                         @"能达速递",
                         
                         @"速尔快递",
                         
                         @"希伊艾斯CCES",
                         
                         @"全一快递",
                         
                         @"优速快递",
                         
                         @"龙邦速递",
                         
                         @"佳吉快运",
                         
                         @"中铁快运",
                         
                         @"联昊通速递",
                         
                         @"元智捷诚快递",
                         
                         @"华企快运",
                         
                         @"星辰急便",
                         
                         @"民航华驿",
                         
                         @"京广速递",
                         
                         @"递达速运",
                         
                         @"全日通快递",
                         
                         @"民邦速递",
                         
                         @"宅急便",
                         
                         @"捷特快递",
                         
                         @"丰达速递",
                         
                         @"忠信达快递@",
                         
                         @"D速快递",
                         
                         @"全峰快递",
                         
                         @"凤凰快递",
                         
                         @"如风达快递",
                         
                         @"快捷速递",
                         
                         @"德邦快递",
                         
                         @"邮政平邮/包裹",
                         
                         @"立即送快递",
                         
                         @"城市100",
                         
                         @"中铁飞豹快递",
                         
                         @"共速达快递",
                         
                         @"海盟速递",
                         
                         @"加运美速递",
                         
                         @"跨越速运",
                         
                         @"联邦快递",
                         
                         @"民航快递",
                         
                         @"门对门快递"
                         , nil];
    }
    return _mailCompanys;
  
}

@end
