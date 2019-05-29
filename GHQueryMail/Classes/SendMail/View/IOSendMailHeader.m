//
//  IOSendMailHeader.m
//  GHQueryMail
//
//  Created by zhaozhiwei on 2019/5/9.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import "IOSendMailHeader.h"
#import "Masonry.h"
#import "Header.h"
@interface IOSendMailHeader()

@property (nonatomic , strong) UILabel *title;
@property (nonatomic , strong) UIImageView *icon;

@end
@implementation IOSendMailHeader

- (void)setMailCompany:(NSString *)mailCompany {
    _mailCompany = mailCompany;
    self.title.text = mailCompany;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setupUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setupUI {

    [self addSubview:self.chose];
    [self.chose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.centerY.equalTo(self);
        make.width.equalTo(@100);
        make.top.equalTo(self).offset(5);
        make.bottom.equalTo(self).offset(-5);

    }];
    
    [self addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.chose.mas_left).offset(-20);
        make.centerY.equalTo(self);
        make.height.equalTo(self.chose);
        make.left.equalTo(self).offset(20);
    }];
}

- (void)clickButton: (UIButton *)button {
    if (self.choseBlock) {
        self.choseBlock();
    }
}

- (UIButton *)chose {
    if (_chose == nil) {
        _chose = [[UIButton alloc]init];
        [_chose setTitle:@"选择快递公司" forState:UIControlStateNormal];
        _chose.backgroundColor = RGBCOLOR(85, 150, 229);
        _chose.titleLabel.font = [UIFont systemFontOfSize:13];
        _chose.layer.masksToBounds = YES;
        _chose.layer.cornerRadius = 5;
        [_chose addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chose;
}

- (UIImageView *)icon {
    if (_icon == nil) {
        _icon = [[UIImageView alloc]init];
    }
    return _icon;
}

- (UILabel *)title {
    if (_title == nil) {
        _title = [[UILabel alloc]init];
        _title.textColor = [UIColor blackColor];
        _title.text = @"点击选择快递公司";
    }
    return _title;
}

@end
