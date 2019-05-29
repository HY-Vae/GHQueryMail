//
//  IOHistoryCell.m
//  GHQueryMail
//
//  Created by zhaozhiwei on 2019/4/23.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import "IOHistoryCell.h"
#import "IOMailModel.h"
#import "Masonry.h"
#import "IOMaiDetailsModel.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "Header.h"

@interface IOHistoryCell()

@property (nonatomic , strong) UILabel *time;
@property (nonatomic , strong) UILabel *date;
@property (nonatomic , strong) UILabel *content;
@property (nonatomic , strong) UIView *line;
@property (nonatomic , strong) UIImageView *imgView;
@property (nonatomic , strong) UILabel *title;
@property (nonatomic , strong) UIButton *phone;
@property (nonatomic , strong) UILabel *num;

@end

@implementation IOHistoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)setMailModel:(IOMailModel *)mailModel {
    _mailModel = mailModel;
      [self.imgView  sd_setImageWithURL:[NSURL URLWithString:mailModel.logo] placeholderImage:[UIImage imageNamed:@"empty"]];
    self.title.text = mailModel.expName;
    NSMutableArray *list = [NSMutableArray array];
    for (NSDictionary *dict in mailModel.list) {
        IOMaiDetailsModel *maiDetailsModel = [IOMaiDetailsModel mj_objectWithKeyValues:dict];
        [list addObject:maiDetailsModel];
    }
    IOMaiDetailsModel *detailsModel = list.firstObject;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datestr = [dateFormatter dateFromString:detailsModel.time];

    NSDateFormatter *formatterTime = [[NSDateFormatter alloc] init];
    NSDateFormatter *formatterDate = [[NSDateFormatter alloc] init];
    [formatterTime setDateFormat:@"HH:mm:ss"];
    [formatterDate setDateFormat:@"YYYY-MM-dd"];
    NSString *time = [formatterTime stringFromDate:datestr];
    NSString *date = [formatterDate stringFromDate:datestr];

    self.time.text = time;
    self.date.text = date;
    self.content.text = detailsModel.status;
    self.num.text = mailModel.number;
}

- (void)setupUI {
    [self addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(20);
        make.width.height.equalTo(@50);
    }];
    
    
    [self addSubview:self.time];
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_bottom).offset(10);
        make.left.equalTo(self).offset(20);
    }];
    
    [self addSubview:self.date];
    [self.date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.time.mas_bottom).offset(5);
        make.centerX.equalTo(self.time);
    }];
    
    [self addSubview:self.content];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.date.mas_right).offset(20);
        make.top.equalTo(self.time);
        make.right.equalTo(self).offset(-20);
    }];
    
    [self addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@1);
    }];
    
    [self addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView);
        make.left.equalTo(self.content);
    }];
    
    [self addSubview:self.num];
    [self.num mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.imgView);
        make.left.equalTo(self.title);
    }];
    
    [self addSubview:self.phone];
    [self.phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(self.imgView);
        make.width.height.equalTo(@50);
    }];
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
- (UIButton *)phone {
    if (_phone == nil) {
        _phone = [[UIButton alloc]init];
        [_phone setImage:[UIImage imageNamed:@"phone@2x"] forState:UIControlStateNormal];
        [_phone addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _phone;
}
- (UIView *)line {
    if (_line == nil) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = [UIColor lightGrayColor];
        _line.alpha = 0.4;
    }
    return _line;
}


- (UILabel *)content {
    if (_content == nil) {
        _content = [[UILabel alloc]init];
        _content.textColor = [UIColor blackColor];
        _content.font = [UIFont systemFontOfSize:14];
        _content.numberOfLines = 2;
    }
    return _content;
}

- (UILabel *)num {
    if (_num == nil) {
        _num = [[UILabel alloc]init];
        _num.font = [UIFont systemFontOfSize:12];
        _num.textColor = RGBCOLOR(85, 150, 229);

    }
    return _num;
}
- (UILabel *)date {
    if (_date == nil) {
        _date = [[UILabel alloc]init];
        _date.textColor = [UIColor lightGrayColor];
        _date.font = [UIFont systemFontOfSize:12];
    }
    return _date;
}

- (UIImageView *)imgView  {
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc]init];
    }
    return _imgView;
}

- (UILabel *)title {
    if (_title == nil) {
        _title = [[UILabel alloc]init];
        _title.textColor = [UIColor blackColor];
        _title.font = [UIFont systemFontOfSize:20];
    }
    return _title;
}

- (UILabel *)time {
    if (_time == nil) {
        _time = [[UILabel alloc]init];
        _time.textColor = [UIColor blackColor];
        _time.font = [UIFont systemFontOfSize:12];
    }
    return _time;
}
@end
