//
//  IOMineCell.m
//  GHQueryMail
//
//  Created by zhaozhiwei on 2019/5/10.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import "IOMineCell.h"
#import "Header.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"

@interface IOMineCell()

@property (nonatomic , strong) UIImageView *icon;
@property (nonatomic , strong) UILabel *title;
@property (nonatomic , strong) UIView *line;
@property (nonatomic , strong) UILabel *details;

@end

@implementation IOMineCell

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    self.line.hidden = NO;
    self.details.hidden = YES;
    NSUInteger bytesCache = [[SDImageCache sharedImageCache] getSize];
    float MBCache = bytesCache/1024/1024.0;
    self.details.text = [NSString stringWithFormat:@"%.2fM",MBCache];
    if (indexPath.section ==0) {
        switch (indexPath.row) {
            case 0:
                self.title.text = @"历史查询";
                self.icon.image = [UIImage imageNamed:@"history"];
                break;
            case 1:
                self.title.text = @"我的收藏";
                self.line.hidden = YES;
                self.icon.image = [UIImage imageNamed:@"shoucang"];
                break;
            default:
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0:
                self.title.text = @"清除缓存";
                self.details.hidden = NO;
                self.icon.image = [UIImage imageNamed:@"delete"];
                break;
            case 1:
                self.icon.image = [UIImage imageNamed:@"xiugai"];
                self.title.text = @"修改密码";
                break;
            case 2:
                self.title.text = @"意见反馈";
                self.icon.image = [UIImage imageNamed:@"yijianjianyi"];
                break;
            case 3:
                self.title.text = @"分享给朋友";
                self.line.hidden = YES;
                self.icon.image = [UIImage imageNamed:@"tubiaolunkuo-"];
                break;
            default:
                break;
        }
    }
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@(20));
    }];
    
    [self addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(10);
        make.centerY.equalTo(self.icon);
    }];
    
    [self addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon);
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self);
        make.height.equalTo(@(1));
    }];
    
    [self addSubview:self.details];
    [self.details mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self.icon);
    }];
}

- (UIView *)line {
    if (_line == nil) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = [UIColor lightGrayColor];
        _line.alpha = 0.3;
    }
    return _line;
}

- (UILabel *)details {
    if (_details == nil) {
        _details = [[UILabel alloc]init];
        _details.text = @"是标题";
        _details.font  =[UIFont systemFontOfSize:13];
        _details.textColor = [UIColor darkGrayColor];
    }
    return _details;
}

- (UILabel *)title {
    if (_title == nil) {
        _title = [[UILabel alloc]init];
        _title.text = @"是标题";
        _title.font  =[UIFont systemFontOfSize:13];
        _title.textColor = [UIColor darkGrayColor];
    }
    return _title;
}

- (UIImageView *)icon {
    if (_icon == nil) {
        _icon = [[UIImageView alloc]init];
        _icon.layer.masksToBounds = YES;
        _icon.layer.cornerRadius = 10;
    }
    return _icon;
}

@end
