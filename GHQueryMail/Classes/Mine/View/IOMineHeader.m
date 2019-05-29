//
//  IOMineHeader.m
//  GHQueryMail
//
//  Created by zhaozhiwei on 2019/5/10.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import "IOMineHeader.h"
#import "Masonry.h"
#import "Header.h"
#import <AVOSCloud/AVOSCloud.h>

@interface IOMineHeader()
@property (nonatomic , strong) UIImageView *avatar;
@property (nonatomic , strong) UILabel *login;

@end

@implementation IOMineHeader

- (void)reloadData {
    
}
- (void)Login: (NSNotification *)noti {
    NSDictionary *dict = noti.object;
    self.login.text = dict[@"name"];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setupUI];
        self.backgroundColor = RGBCOLOR(85, 150, 229);
        [self addGes];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(Login:)
                                                     name:@"NotificationNameLoginSuccess"
                                                   object:nil];
    }
    return self;
}

- (void)addGes {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tap.numberOfTouchesRequired = 1; //手指数
    tap.numberOfTapsRequired = 1; //tap次数
    [self addGestureRecognizer:tap];
}

- (void)tap:(UITapGestureRecognizer *)gesture {
    if (self.didClickBlock) {
        self.didClickBlock();
    }
}

- (void)setupUI {
    [self addSubview:self.avatar];
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-5);
        make.width.height.equalTo(@50);
    }];
    
    [self addSubview:self.login];
    [self.login mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatar.mas_bottom).offset(5);
        make.centerX.equalTo(self.avatar);
    }];
}

- (UILabel *)login {
    if (_login == nil) {
        _login = [[UILabel alloc]init];
        _login.text = @"点击登录";
        _login.textColor = [UIColor whiteColor];
        _login.font = [UIFont systemFontOfSize:12];
    }
    return _login;
}

- (UIImageView *)avatar {
    if (_avatar == nil) {
        _avatar = [[UIImageView alloc]init];
        _avatar.image = [UIImage imageNamed:@"touxiang"];
        _avatar.layer.masksToBounds = YES;
        _avatar.layer.cornerRadius = 10;
    }
    return _avatar;
}



@end
