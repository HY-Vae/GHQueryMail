//
//  IOSuggestViewController.m
//  GHQueryMail
//
//  Created by zhaozhiwei on 2019/5/10.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import "IOSuggestViewController.h"
#import "GHContentView.h"
#import "ToastTool.h"
#import "Header.h"
#import "Masonry.h"
#import "ToastTool.h"

@interface IOSuggestViewController ()
@property (nonatomic , strong)UILabel *suggest;

@end

@implementation IOSuggestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"建议反馈";

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self setupUI];
    

}

- (void)setupUI {
    UILabel *tip = [[UILabel alloc]init];
    tip.text = @"为提升用户体验,请您随心所欲提出您的意见或者批评";
    tip.numberOfLines = 0;
    tip.textColor = [UIColor lightGrayColor];

    [self.view addSubview:tip];
    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(self.view).offset(kSafeAreaTopHeight + 20);
        make.right.equalTo(self.view).offset(-20);

    }];
    
    UILabel *suggest = [[UILabel alloc]init];
    suggest.numberOfLines = 0;
    suggest.text = @"点击请输入你的建议";
    [self.view addSubview:suggest];
    [suggest mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tip);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(tip.mas_bottom).offset(5);
    }];
    self.suggest = suggest;
    suggest.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    
    [suggest addGestureRecognizer:tap];
    
    
    UIButton *sure = [[UIButton alloc]init];
    [sure setTitle:@"确定" forState:UIControlStateNormal];
    [sure setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [sure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sure.backgroundColor = RGBCOLOR(85, 150, 229);
    sure.layer.masksToBounds = YES;
    sure.layer.cornerRadius = 8;
    [sure addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sure];
    [sure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@50);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10-kSafeAreaBottomHeight);
    }];
}

- (void)clickButton: (UIButton *)button {
    if (self.suggest.text.length) {
        [ToastTool makeToast:@"提交成功" targetView:self.view];
    }else {
        [ToastTool makeToast:@"请您填写建议" targetView:self.view];
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];

    });
}

- (void)tap: (UITapGestureRecognizer *)gesture {
    
    GHContentView *alert = [[GHContentView alloc]init];
    alert.alertHeight = 220;
    alert.alertTitle = @"建议反馈";
    alert.positionType = GHCustomAlertViewPositionType_bottom;
    alert.showFinish  = ^{
        
    };
    weakself(self);
    alert.contentBlock = ^(NSString *content) {
        weakSelf.suggest.text = content;
    };
    
    [alert show];
}
@end
