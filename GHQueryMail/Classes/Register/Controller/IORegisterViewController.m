//
//  IORegisterViewController.m
//  GHQueryMail
//
//  Created by zhaozhiwei on 2019/5/10.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import "IORegisterViewController.h"
#import "Header.h"
#import "Masonry.h"
#import "IOTabBarController.h"
#import <AVOSCloud/AVOSCloud.h>

@interface IORegisterViewController ()
@property (nonatomic , strong) UILabel *userName;
@property (nonatomic , strong) UITextField *userNameTextField;
@property (nonatomic , strong) UILabel *password;
@property (nonatomic , strong) UILabel *againPassword;
@property (nonatomic , strong) UITextField *passwordTextField;
@property (nonatomic , strong) UITextField *againPasswordTextField;
@property (nonatomic , strong) UIView *userNameLine;
@property (nonatomic , strong) UIView *passwordLine;
@property (nonatomic , strong) UIView *againPasswordLine;
@property (nonatomic , strong) UIButton *login;
@end

@implementation IORegisterViewController

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
    
    UILabel *againPassword = [[UILabel alloc]init];
    againPassword.text = @"再次输入密码";
    [self.view addSubview:againPassword];
    [againPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordLine);
        make.top.equalTo(passwordLine.mas_bottom).offset(10);
    }];
    
    UITextField *againPasswordTextField = [[UITextField alloc]init];
    againPasswordTextField.placeholder = @"请再次输入用户密码";
    
    [self.view addSubview:againPasswordTextField];
    [againPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(againPassword);
        make.top.equalTo(againPassword.mas_bottom).offset(10);
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
    
    UIButton *registerButton = [[UIButton alloc]init];
    [registerButton setTitle:@"注 册" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registerButton.backgroundColor = RGBCOLOR(85, 150, 229);
    registerButton.layer.masksToBounds = YES;
    registerButton.layer.cornerRadius = 8;
    [registerButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(againPasswordLine);
        make.height.equalTo(@50);
        make.top.equalTo(againPasswordLine.mas_bottom).offset(20);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)clickClose {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickButton: (UIButton *)button {
    
    NSString *username = self.userNameTextField.text;
    NSString *password = self.passwordTextField.text;
    if (username && password) {
        // LeanCloud - 注册
        // https://leancloud.cn/docs/leanstorage_guide-objc.html#用户名和密码注册
        AVUser *user = [AVUser user];
        user.username = username;
        user.password = password;
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self performSegueWithIdentifier:@"fromSignUpToProducts" sender:nil];
            } else {
                NSLog(@"注册失败 %@", error);
            }
        }];
    }
}

@end
