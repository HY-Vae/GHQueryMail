//
//  IOSendMailHeader.h
//  GHQueryMail
//
//  Created by zhaozhiwei on 2019/5/9.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IOSendMailHeader : UIView
typedef void(^IOSendMailHeaderChoseBlock)(void);
@property (nonatomic , copy) IOSendMailHeaderChoseBlock choseBlock;
@property (nonatomic , strong) UIButton *chose;
@property (nonatomic , copy) NSString *mailCompany;

@end

NS_ASSUME_NONNULL_END
