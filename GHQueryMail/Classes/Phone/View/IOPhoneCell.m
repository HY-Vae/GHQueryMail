//
//  IOPhoneCell.m
//  GHQueryMail
//
//  Created by zhaozhiwei on 2019/4/23.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import "IOPhoneCell.h"
#import "IOPhoneModel.h"
#import "Masonry.h"
#import "Header.h"

@interface IOPhoneCell()
@property (nonatomic , strong) UILabel *title;
@property (nonatomic , strong) UILabel *phone;
@property (nonatomic , strong) UIButton *callPhone;

@end
@implementation IOPhoneCell

- (void)setPhoneModel:(IOPhoneModel *)phoneModel {
    _phoneModel = phoneModel;
    self.title.text = phoneModel.name;
    self.phone.text = phoneModel.phone;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self).offset(10);

    }];
    [self addSubview:self.phone];
    [self.phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title);
        make.top.equalTo(self.title.mas_bottom).offset(5);
    }];
    
    [self addSubview:self.callPhone];
    [self.callPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@50);
    }];
}

- (void)clickButton: (UIButton *)button {
    [self callupWithNum:self.phoneModel.phone];
}

- (void)callupWithNum: (NSString *)num {
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@",num];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
}

- (UILabel *)title {
    if (_title == nil) {
        _title = [[UILabel alloc]init];
        _title.textColor = [UIColor blackColor];
        _title.numberOfLines = 2;
    }
    return _title;
}

- (UIButton *)callPhone {
    if (_callPhone == nil) {
        _callPhone = [[UIButton alloc]init];
        [_callPhone setImage:[UIImage imageNamed:@"phone@2x"] forState:UIControlStateNormal];
        [_callPhone addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _callPhone;
}

- (UILabel *)phone {
    if (_phone == nil) {
        _phone = [[UILabel alloc]init];
        _phone.textColor = [UIColor darkGrayColor];
        _phone.font = [UIFont systemFontOfSize:12];
    }
    return _phone;
}

@end
