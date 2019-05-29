//
//  IOMineHeader.h
//  GHQueryMail
//
//  Created by zhaozhiwei on 2019/5/10.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^IOMineHeaderDidClickBlock)(void);
@interface IOMineHeader : UIView
@property (nonatomic , copy) IOMineHeaderDidClickBlock didClickBlock;

- (void)reloadData;
@end

NS_ASSUME_NONNULL_END
