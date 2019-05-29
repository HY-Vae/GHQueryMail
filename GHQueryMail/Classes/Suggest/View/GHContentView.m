//
//  GHContentView.m
//  Field
//
//  Created by 赵治玮 on 2017/11/17.
//  Copyright © 2017年 赵治玮. All rights reserved.
//

#import "GHContentView.h"
#import "IQKeyboardManager.h"
#import "Header.h"

@interface GHContentView()
@property (nonatomic , strong) UITextView *textView;
@end
@implementation GHContentView

- (void)setupDefault {
    [super setupDefault];
    [self setupUI];
    [IQKeyboardManager sharedManager].enable = NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset = kbHeight;
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.contentView.frame = CGRectMake(0, kScreenHeight-offset - self.alertHeight, self.contentView.frame.size.width, self.contentView.frame.size.height);
        }];
    }
    [self.textView becomeFirstResponder];
}
///键盘消失事件
- (void)keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.contentView.frame = CGRectMake(0, kScreenHeight, self.contentView.frame.size.width, self.contentView.frame.size.height);
    }];
    if (self.contentBlock) {
        self.contentBlock(self.textView.text);
    }
    [self dismiss];
  
}

- (void)setupUI {
    [self.contentView addSubview:self.textView];
}

- (UITextView *)textView {
    if (_textView == nil) {
        _textView = [[UITextView alloc]init];
        _textView.frame = self.picker.frame;
        _textView.textColor = [UIColor lightGrayColor];
    }
    return _textView;
}
@end
