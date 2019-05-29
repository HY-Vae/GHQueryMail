//
//  IOViewController.m
//  GHQueryMail
//
//  Created by zhaozhiwei on 2019/4/23.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import "IOViewController.h"
#import "Header.h"
#import "GHHTTPManager.h"
#import "MJExtension.h"
#import "IOMailModel.h"
#import "UIImageView+WebCache.h"
#import "IOMaiDetailsViewController.h"
#import "IOMaiDetailsModel.h"
#import "CacheHelper.h"
#import "GHDBHelper.h"
#import "IOMailManager.h"
#import "GHCameraModuleViewController.h"
#import "GHPrivacyAuthTool.h"
#import "RealReachability.h"
#import "ToastTool.h"

@interface IOViewController ()<UITextFieldDelegate>
@property (nonatomic , strong) UILabel *tip;
@property (nonatomic , strong) UIImageView *imageView;
@property (nonatomic , strong) UITextField *textFieldNum ;

@end

@implementation IOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.navigationItem.title = @"快递助手";
    
    UIView *backGround = [[UIView alloc]init];
    backGround.backgroundColor = [UIColor whiteColor];
    backGround.frame = CGRectMake(0, kSafeAreaTopHeight, kScreenWidth, 170);
    [self.view addSubview:backGround];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"快递单号";
    label.frame = CGRectMake(10,10, backGround.frame.size.width - 20, 44);
    [backGround addSubview:label];
    
    UITextField *textFieldNum = [[UITextField alloc]init];
    textFieldNum.placeholder = @"请输入或扫描运单号";
    textFieldNum.frame = CGRectMake(10, CGRectGetMaxY(label.frame), label.frame.size.width, 50);
    textFieldNum.delegate = self;
    textFieldNum.font = [UIFont boldSystemFontOfSize:20];
    [backGround addSubview:textFieldNum];
    self.textFieldNum = textFieldNum;
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor lightGrayColor];
    line.alpha = 0.5;
    line.frame = CGRectMake(10, CGRectGetMaxY(textFieldNum.frame), textFieldNum.frame.size.width, 1);
    [backGround addSubview:line];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(10, CGRectGetMaxY(line.frame) + 10 + 10,20, 20);
    [backGround addSubview:imageView];
    self.imageView = imageView;
    
    UILabel *tip = [[UILabel alloc]init];
    tip.text = @"自动匹配快递公司";
    tip.frame = CGRectMake(CGRectGetMaxX(imageView.frame) + 10, CGRectGetMaxY(line.frame) + 10,line.frame.size.width, 44);
    tip.font = [UIFont systemFontOfSize:14];
    [backGround addSubview:tip];
    self.tip = tip;
    
    UIButton *sure = [[UIButton alloc]init];
    [sure setTitle:@"查询" forState:UIControlStateNormal];
    [sure setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [sure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sure.backgroundColor = RGBCOLOR(85, 150, 229);
    sure.layer.masksToBounds = YES;
    sure.layer.cornerRadius = 8;
    [sure addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    sure.frame = CGRectMake(10,CGRectGetMaxY(backGround.frame)+ 20,kScreenWidth  - 20, 50);
    [self.view addSubview:sure];
    
    UIButton *scan = [[UIButton alloc]init];
    [scan setImage:[UIImage imageNamed:@"saoyisao@2x"] forState:UIControlStateNormal];
    [scan addTarget:self action:@selector(clickScan:) forControlEvents:UIControlEventTouchUpInside];
    scan.frame = CGRectMake(0, 0, 44, 44);
    [self.view addSubview:sure];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:scan];
    
    [[GHHTTPManager sharedManager] queryMailWithNum:@"780098068058" finishedBlock:^(id responseObject, NSError *error) {
        NSLog(@"responseObject%@",responseObject);
        NSLog(@"responseObject%@",error);

    }];
}

- (void)clickScan: (UIButton *)button {
    if (TARGET_IPHONE_SIMULATOR) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"不支持模拟器" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    weakself(self);
    [[GHPrivacyAuthTool share] checkPrivacyAuthWithType:GHPrivacyCamera isPushSetting:YES title:@"相机权限未开启" message:@"请在iPhone的【设置->隐私->相机】选项中，允许快递小助手采访问您的相机" withHandle:^(BOOL granted, GHAuthStatus status) {
        if (granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                GHCameraModuleViewController *vc = [[GHCameraModuleViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;  //隐藏tabbar
                [weakSelf.navigationController pushViewController:vc animated:YES];
            });
        }
    }];
}

- (void)clickButton: (UIButton *)button {
    if (self.textFieldNum.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先输入快递单号" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    weakself(self);
    [ToastTool makeToastActivity:self.view];
    [[GHHTTPManager sharedManager] queryMailWithNum:self.textFieldNum.text finishedBlock:^(id responseObject, NSError *error) {
        [ToastTool hideToastActivity:weakSelf.view];

        if (error == nil) {
            NSString *status = responseObject[@"status"];
            if ([status isEqualToString:@"205"]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"快递单号无效" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                    [alertView show];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    return ;
                });
            } else {
                NSDictionary *result = responseObject[@"result"];
                [[IOMailManager share] saveRecordWithDict:result];
                NSMutableArray *listArr = [NSMutableArray array];
                NSArray *list = result[@"list"];
                for (NSDictionary *dict in list) {
                    IOMaiDetailsModel *maiDetailsModel = [IOMaiDetailsModel mj_objectWithKeyValues:dict];
                    [listArr addObject:maiDetailsModel];
                }
                IOMailModel *mailModel = [IOMailModel mj_objectWithKeyValues:result];
                mailModel.list = listArr.copy;
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.tip.text = mailModel.expName;
                    [weakSelf.view endEditing:YES];
                    [weakSelf.imageView sd_setImageWithURL:[NSURL URLWithString:mailModel.logo]];
                    
                    IOMaiDetailsViewController *vc = [[IOMaiDetailsViewController alloc]init];
                    vc.num = mailModel.number;
                    [weakSelf.navigationController pushViewController:vc animated:   YES];
                    
                });
            }
        } else {

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ToastTool hideToastActivity:weakSelf.view];
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"快递单号输入错误,请重新输入" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alertView show];
            });
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
