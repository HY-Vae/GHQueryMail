//
//  IOLoginViewController.m
//  GHQueryMail
//
//  Created by zhaozhiwei on 2019/5/10.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import "IOLoginViewController.h"
#import "Header.h"
#import "Masonry.h"
#import "IOTabBarController.h"
#import "IORegisterViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MJExtension.h"

@interface IOLoginViewController ()

@property (nonatomic , strong) UILabel *userName;
@property (nonatomic , strong) UITextField *userNameTextField;
@property (nonatomic , strong) UILabel *password;
@property (nonatomic , strong) UITextField *passwordTextField;
@property (nonatomic , strong) UIView *userNameLine;
@property (nonatomic , strong) UIView *passwordLine;
@property (nonatomic , strong) UIButton *login;
@property (nonatomic , strong) UIButton *registerButton;

@end

@implementation IOLoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
}

- (void)setupUI {
    UIButton *close = [[UIButton alloc]init];
    [close setImage:[UIImage imageNamed:@"close@2x"] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:close];
    [close mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(self.view).offset(kSafeAreaTopHeight + 20);
        make.width.height.equalTo(@30);
    }];
    
    UIImageView *logo = [[UIImageView alloc]init];
    logo.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:logo];
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(close);
        make.width.height.equalTo(@80);
    }];
    
    UILabel *userName = [[UILabel alloc]init];
    userName.text = @"用户名";
    [self.view addSubview:userName];
    [userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(self.view).offset(200);
    }];
    
    UITextField *userNameTextField = [[UITextField alloc]init];
    userNameTextField.placeholder = @"请输入用户名";
    self.userNameTextField = userNameTextField;
    [self.view addSubview:userNameTextField];
    [userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userName);
        make.top.equalTo(userName.mas_bottom).offset(10);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@44);
    }];
    
    UIView *userNameLine = [[UIView alloc]init];
    userNameLine.backgroundColor = [UIColor lightGrayColor];
    userNameLine.alpha =.3;
    [self.view addSubview:userNameLine];
    [userNameLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(userNameTextField);
        make.height.equalTo(@1);
    }];

    UILabel *password = [[UILabel alloc]init];
    password.text = @"密码";
    [self.view addSubview:password];
    [password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userNameTextField);
        make.top.equalTo(userNameTextField.mas_bottom).offset(10);
    }];
    
    UITextField *passwordTextField = [[UITextField alloc]init];
    passwordTextField.placeholder = @"请输入用户密码";
    self.passwordTextField = passwordTextField;

    [self.view addSubview:passwordTextField];
    [passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(password);
        make.top.equalTo(password.mas_bottom).offset(10);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@44);
    }];
    
    UIView *passwordLine = [[UIView alloc]init];
    passwordLine.backgroundColor = [UIColor lightGrayColor];
    passwordLine.alpha =.3;
    [self.view addSubview:passwordLine];
    [passwordLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(passwordTextField);
        make.height.equalTo(@1);
    }];
    
    UIButton *login = [[UIButton alloc]init];
    [login setTitle:@"登录" forState:UIControlStateNormal];
    [login setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    login.backgroundColor = RGBCOLOR(85, 150, 229);
    login.layer.masksToBounds = YES;
    login.layer.cornerRadius = 8;
    [login addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:login];
    [login mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(passwordTextField);
        make.height.equalTo(@50);
        make.top.equalTo(passwordLine.mas_bottom).offset(20);
    }];
    
    UIButton *registerButton = [[UIButton alloc]init];
    [registerButton setTitle:@"注册用户" forState:UIControlStateNormal];
    [registerButton setTitleColor: RGBCOLOR(85, 150, 229) forState:UIControlStateNormal];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [registerButton addTarget:self action:@selector(clickregisterButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(login);
        make.height.equalTo(@30);
        make.top.equalTo(login.mas_bottom).offset(5);
    }];
    
}

- (void)clickClose {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickregisterButton: (UIButton *)button {
    
    IORegisterViewController *vc = [[IORegisterViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)clickButton: (UIButton *)button {
    
    NSString *username = self.userNameTextField.text;
    NSString *password = self.passwordTextField.text;
    if (username && password) {
        // LeanCloud - 登录
        // https://leancloud.cn/docs/leanstorage_guide-objc.html#登录
        [AVUser logInWithUsernameInBackground:username password:password block:^(AVUser *user, NSError *error) {
            if (error) {
                NSLog(@"登录失败 %@", error);
            } else {
                NSString *name = user.username;
                NSString *password = user.password;

                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                dict[@"name"] = name;
                dict[@"password"] = password;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationNameLoginSuccess" object:dict];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
}

@end
