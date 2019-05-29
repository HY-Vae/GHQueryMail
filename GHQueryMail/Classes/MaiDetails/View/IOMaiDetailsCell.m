//
//  IOMaiDetailsCell.m
//  GHQueryMail
//
//  Created by zhaozhiwei on 2019/4/23.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import "IOMaiDetailsCell.h"
#import "Masonry.h"
#import "IOMaiDetailsModel.h"
#import "MJExtension.h"
#import "Header.h"

@interface IOMaiDetailsCell()

@property (nonatomic , strong) UILabel *time;
@property (nonatomic , strong) UILabel *date;
@property (nonatomic , strong) UIView *line;
@property (nonatomic , strong) UIView *bottomLine;
@property (nonatomic , strong) UILabel *content;

@end

@implementation IOMaiDetailsCell

- (void)setLineStatusShow {
    self.line.hidden = NO;
}
- (void)setLineStatusHidden {
    self.line.hidden = YES;
}

- (void)setMaiDetailsModel:(IOMaiDetailsModel *)maiDetailsModel {
    _maiDetailsModel = maiDetailsModel;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datestr = [dateFormatter dateFromString:maiDetailsModel.time];
    
    NSDateFormatter *formatterTime = [[NSDateFormatter alloc] init];
    NSDateFormatter *formatterDate = [[NSDateFormatter alloc] init];
    [formatterTime setDateFormat:@"HH:mm:ss"];
    [formatterDate setDateFormat:@"YYYY-MM-dd"];
    NSString *time = [formatterTime stringFromDate:datestr];
    NSString *date = [formatterDate stringFromDate:datestr];

    self.time.text = time;
    self.date.text = date;
    self.content.text = maiDetailsModel.status;
    
    if (maiDetailsModel.indexPath.row == 0) {
        self.time.textColor = RGBCOLOR(85, 150, 229);
        self.date.textColor = RGBCOLOR(85, 150, 229);
        self.content.textColor =RGBCOLOR(85, 150, 229);
    } else {
        self.time.textColor = [UIColor blackColor];
        self.date.textColor = [UIColor lightGrayColor];
        self.content.textColor = [UIColor lightGrayColor];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.time];
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(20);
    }];
    
    [self addSubview:self.date];
    [self.date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.time.mas_bottom).offset(5);
        make.centerX.equalTo(self.time);
    }];
    
    [self addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.date.mas_bottom).offset(5);
        make.bottom.equalTo(self).offset(-10);
        make.centerX.equalTo(self.time);
        make.width.equalTo(@1);
    }];

    [self addSubview:self.content];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.date.mas_right).offset(20);
        make.top.equalTo(self.time);
        make.right.equalTo(self).offset(-20);
    }];
}


- (UIView *)bottomLine {
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc]init];
        _bottomLine.backgroundColor = [UIColor lightGrayColor];
        _bottomLine.alpha = 0.4;
    }
    return _bottomLine;
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

- (UILabel *)date {
    if (_date == nil) {
        _date = [[UILabel alloc]init];
        _date.textColor = [UIColor lightGrayColor];
        _date.font = [UIFont systemFontOfSize:12];
    }
    return _date;
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
