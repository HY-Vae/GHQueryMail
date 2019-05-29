//
//  IOSendMailCell.m
//  GHQueryMail
//
//  Created by zhaozhiwei on 2019/5/9.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import "IOSendMailCell.h"
#import "Masonry.h"
#import "Header.h"

@interface IOSendMailCell()<UITextFieldDelegate>
@property (nonatomic , strong) UILabel *title;
@property (nonatomic , strong) UIView *line;
@property (nonatomic , strong) UITextField *textField;

@end
@implementation IOSendMailCell

- (void)clearData {
    self.textField.text = @"";
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    
    switch (indexPath.row) {
        case 0:
            self.title.text = @"姓名";
            self.textField.placeholder = indexPath.section == 0 ? @"请输入发件人姓名":@"请输入收件人姓名";
            break;
        case 1:
            self.title.text = @"电话";
            self.textField.placeholder = indexPath.section == 0 ? @"请输入发件人电话":@"请输入收件人电话";
            break;
        case 2:
            self.title.text = @"地址";
            self.textField.placeholder = indexPath.section == 0 ?@"请输入发件人详细地址":@"请输入收件人详细地址";
            break;
        default:
            break;
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier
                 ]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextFieldTextDidChangeNotification object:self.textField];

    }
    return self;
}
- (void)textChange: (NSNotification *)noti {
    
    if (self.inputBlock) {
        self.inputBlock(self.textField.text,self.indexPath);
    }
}
- (void)setupUI {
    
    [self addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self);
        make.width.equalTo(@50);
        make.bottom.equalTo(self);
    }];
    
    [self addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title.mas_right);
        make.right.equalTo(self).offset(-20);
        make.top.bottom.equalTo(self);
    }];
    
    [self addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title);
        make.right.equalTo(self).offset(-20);
        make.bottom.equalTo(self);
        make.height.equalTo(@1);
    }];
}

- (UIView *)line {
    if (_line == nil) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = [UIColor lightGrayColor];
        _line.alpha = 0.4;
    }
    return _line;
}

- (UITextField *)textField {
    if (_textField == nil) {
        _textField = [[UITextField alloc]init];
        _textField.textColor = [UIColor blackColor];
        _textField.font = [UIFont systemFontOfSize:13];
        _textField.tintColor = RGBCOLOR(85, 150, 229);
        _textField.delegate = self;
    }
    return _textField;
}

- (UILabel *)title {
    if (_title == nil) {
        _title = [[UILabel alloc]init];
        _title.textColor = [UIColor blackColor];
        _title.font = [UIFont systemFontOfSize:13];
    }
    return _title;
}

@end
