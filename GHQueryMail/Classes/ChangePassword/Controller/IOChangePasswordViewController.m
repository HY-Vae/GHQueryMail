//
//  IOChangePasswordViewController.m
//  GHQueryMail
//
//  Created by zhaozhiwei on 2019/5/10.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import "IOChangePasswordViewController.h"
#import "Header.h"
#import "Masonry.h"
#import "ToastTool.h"

@interface IOChangePasswordViewController ()

@end

@implementation IOChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)setupUI {
    UILabel *originalPassword = [[UILabel alloc]init];
    originalPassword.text = @"原密码";
    [self.view addSubview:originalPassword];
    [originalPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(self.view).offset(kSafeAreaTopHeight + 20);
    }];
    
    UITextField *originalPasswordTextField = [[UITextField alloc]init];
    originalPasswordTextField.placeholder = @"请输入原密码";
    [self.view addSubview:originalPasswordTextField];
    [originalPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(originalPassword);
        make.top.equalTo(originalPassword.mas_bottom).offset(10);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@44);
    }];
    
    UIView *originalPasswordLine = [[UIView alloc]init];
    originalPasswordLine.backgroundColor = [UIColor lightGrayColor];
    originalPasswordLine.alpha =.3;
    [self.view addSubview:originalPasswordLine];
    [originalPasswordLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(originalPasswordTextField);
        make.height.equalTo(@1);
    }];
    
    UILabel *newPassword = [[UILabel alloc]init];
    newPassword.text = @"新密码";
    [self.view addSubview:newPassword];
    [newPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(originalPasswordLine);
        make.top.equalTo(originalPasswordLine.mas_bottom).offset(10);
    }];
    
    UITextField *newPasswordTextField = [[UITextField alloc]init];
    newPasswordTextField.placeholder = @"请输入用户密码";
    
    [self.view addSubview:newPasswordTextField];
    [newPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(newPassword);
        make.top.equalTo(newPassword.mas_bottom).offset(10);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@44);
    }];
    
    UIView *passwordLine = [[UIView alloc]init];
    passwordLine.backgroundColor = [UIColor lightGrayColor];
    passwordLine.alpha =.3;
    [self.view addSubview:passwordLine];
    [passwordLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(newPasswordTextField);
        make.height.equalTo(@1);
    }];
    
    UILabel *againNewPassword = [[UILabel alloc]init];
    againNewPassword.text = @"再次输入新密码";
    [self.view addSubview:againNewPassword];
    [againNewPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordLine);
        make.top.equalTo(passwordLine.mas_bottom).offset(10);
    }];
    
    UITextField *againPasswordTextField = [[UITextField alloc]init];
    againPasswordTextField.placeholder = @"请再次输入用户密码";
    
    [self.view addSubview:againPasswordTextField];
    [againPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(againNewPassword);
        make.top.equalTo(againNewPassword.mas_bottom).offset(10);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@44);
    }];
    
    UIView *againPasswordLine = [[UIView alloc]init];
    againPasswordLine.backgroundColor = [UIColor lightGrayColor];
    againPasswordLine.alpha =.3;
    [self.view addSubview:againPasswordLine];
    [againPasswordLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(againPasswordTextField);
        make.height.equalTo(@1);
    }];
    
    UIButton *sure = [[UIButton alloc]init];
    [sure setTitle:@"确 定" forState:UIControlStateNormal];
    [sure setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [sure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sure.backgroundColor = RGBCOLOR(85, 150, 229);
    sure.layer.masksToBounds = YES;
    sure.layer.cornerRadius = 8;
    [sure addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sure];
    [sure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(againPasswordLine);
        make.height.equalTo(@50);
        make.top.equalTo(againPasswordLine.mas_bottom).offset(20);
    }];
}

- (void)clickButton: (UIButton *)button {
    [ToastTool makeToast:@"修改失败" targetView:self.view];                                                                                                                                                                                                                 
    [self.navigationController popViewControllerAnimated:YES];
}

@end
