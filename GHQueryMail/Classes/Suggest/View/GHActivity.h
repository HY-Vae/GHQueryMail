//
//  GHActivity.h
//  GHPasswordManager-OC
//
//  Created by zhaozhiwei on 2019/3/9.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GHActivity : UIActivity

- (instancetype)initWithTitle:(NSString *)title activityImage:(UIImage *)activityImage url:(NSURL *)url activityType:(NSString *)activityType;

@end

NS_ASSUME_NONNULL_END
