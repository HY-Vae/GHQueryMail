//
//  GHContentView.h
//  Field
//
//  Created by 赵治玮 on 2017/11/17.
//  Copyright © 2017年 赵治玮. All rights reserved.
//

#import "GHCustomAlertView.h"

typedef void(^GHContentViewBlock)(NSString *content);
@interface GHContentView : GHCustomAlertView
@property (nonatomic , copy) GHContentViewBlock contentBlock;
@end
