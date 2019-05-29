//
//  GHCustomAlertView.m
//  GHStudy
//
//  Created by 赵治玮 on 2017/11/12.
//  Copyright © 2017年 赵治玮. All rights reserved.
//

#import "GHCustomAlertView.h"
#import "UIView+GHAdd.h"
#import "Header.h"

@interface GHCustomAlertView()

@end
@implementation GHCustomAlertView
#pragma mark - set
- (void)setAlertTitle:(NSString *)alertTitle {
    _alertTitle = alertTitle;
    self.title.text = alertTitle;
    self.title.gh_width = [self sizeWithText:alertTitle font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT, 36)].width;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setupDefault];
    }
    return self;
}

- (instancetype)init {
    if (self == [super init]) {
        [self setupDefault];
    }
    return self;

}
- (void)respondToTapGesture:(UITapGestureRecognizer *)ges {
    [self dismiss];
}
- (void)setupDefault {
    self.frame = [UIApplication sharedApplication].keyWindow.bounds;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:102.0/255];
    self.layer.opacity = 0.0;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.line];
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.cancel];
    [self.contentView addSubview:self.sure];
    [self.contentView addSubview:self.picker];
}
- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self setCenter:[UIApplication sharedApplication].keyWindow.center];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.layer setOpacity:1.0];

        if (self.positionType == GHCustomAlertViewPositionType_bottom) {
            self.contentView.frame = CGRectMake(0, kScreenHeight - self.alertHeight, kScreenWidth, self.alertHeight);
        } else if (self.positionType == GHCustomAlertViewPositionType_center) {
            self.contentView.frame = CGRectMake(0, (kScreenHeight - self.alertHeight)*0.5, kScreenWidth, self.alertHeight);
        } else if (self.positionType == GHCustomAlertViewPositionType_top) {
            self.contentView.frame = CGRectMake(0, 0, kScreenWidth, self.alertHeight);
        }
 
    } completion:^(BOOL finished) {
        if (self.showFinish) {
            self.showFinish();
        }
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        if (self.positionType == GHCustomAlertViewPositionType_bottom) {
            self.contentView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, self.alertHeight);
        } else if (self.positionType == GHCustomAlertViewPositionType_center) {
            self.contentView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, self.alertHeight);
        } else if (self.positionType == GHCustomAlertViewPositionType_top) {
            self.contentView.frame = CGRectMake(0, -self.alertHeight, kScreenWidth, self.alertHeight);
        }
    } completion:^(BOOL finished) {
        [self.layer setOpacity:0.0];

        [self removeFromSuperview];
        if (self.dimissFinish) {
            self.dimissFinish();
        }
    }];
}

- (void)clickButton: (UIButton *)button {
    [self dismiss];
}

#pragma mark - 返回文字的size
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

#pragma mark - 懒加载
- (UIButton *)sure {
    if (_sure == nil) {
        _sure = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 15 - 60, 4, 60, 36)];
        [_sure setTitle:@"确定" forState:UIControlStateNormal];
        [_sure setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_sure addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        _sure.tag = GHCustomAlertViewButtonType_sure;
        _sure.layer.masksToBounds = YES;
        _sure.layer.borderWidth = 0.5;
        _sure.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _sure.layer.cornerRadius = 5;
        _sure.titleLabel.font = [UIFont systemFontOfSize:16];

    }
    return _sure;
}
- (UIButton *)cancel {
    if (_cancel == nil) {
        _cancel = [[UIButton alloc]initWithFrame:CGRectMake(15, 4, 60, 36)];
        [_cancel setTitle:@"取消" forState:UIControlStateNormal];
        [_cancel setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_cancel addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        _cancel.tag = GHCustomAlertViewButtonType_cancel;
        _cancel.layer.masksToBounds = YES;
        _cancel.layer.borderWidth = 0.5;
        _cancel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _cancel.layer.cornerRadius = 5;
        _cancel.titleLabel.font = [UIFont systemFontOfSize:16];

    }
    return _cancel;
}
- (UILabel *)title {
    if (_title == nil) {
        _title = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - 60 ) *0.5, 4, 60, 36)];
        _title.text = self.alertTitle;
        _title.font = [UIFont systemFontOfSize:16];
    }
    return _title;
}
- (UIView *)line {
    if (_line == nil) {
        _line = [[UIView alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth, 0.5)];
        _line.backgroundColor = [UIColor lightGrayColor];
    }
    return _line;
}
- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, self.alertHeight)];
        _contentView.backgroundColor =[UIColor whiteColor];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    }
    return _contentView;
}
- (UIPickerView *)picker {
    if (_picker == nil) {
        _picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth, 220 - 44)];
    }
    return _picker;
}

@end
