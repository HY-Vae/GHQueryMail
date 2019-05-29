//
//  IOTabBarController.m
//  GHQueryMail
//
//  Created by zhaozhiwei on 2019/4/23.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import "IOTabBarController.h"
#import "IOViewController.h"
#import "IOHistoryViewController.h"
#import "IOPhoneViewController.h"
#import "Header.h"
#import "IOSendMailViewController.h"
#import "IOMineViewController.h"

@interface IOTabBarController ()

@end

@implementation IOTabBarController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupVc];
}

#pragma mark - RequestData
- (void)setupVc  {
    
    IOViewController *homeVc = [[IOViewController alloc] init];
    [self addChildViewControllerWithVC:homeVc title:@"快递" image:@"tabBar_mail_normal" selectedImage:@"tabBar_mail_selected"];
    
    IOSendMailViewController *sendMailVc = [[IOSendMailViewController alloc] init];
    [self addChildViewControllerWithVC:sendMailVc title:@"发快递" image:@"tabBar_sendMail_normal" selectedImage:@"tabBar_sendMail_selected"];
    
    IOHistoryViewController *historyVc = [[IOHistoryViewController alloc] init];
    [self addChildViewControllerWithVC:historyVc title:@"历史记录" image:@"tabBar_history_normal" selectedImage:@"tabBar_history_selected"];
    
    IOPhoneViewController *phoneVc = [[IOPhoneViewController alloc] init];
    [self addChildViewControllerWithVC:phoneVc title:@"快递电话" image:@"tabBar_phone_normal" selectedImage:@"tabBar_phone_selected"];
    
    IOMineViewController *mineVc = [[IOMineViewController alloc] init];
    [self addChildViewControllerWithVC:mineVc title:@"个人中心" image:@"tabBar_mine_normal" selectedImage:@"tabBar_mine_selected"];
}

#pragma mark - 构造控制器便利方法
- (void)addChildViewControllerWithVC: (UIViewController *)vc
                               title: (NSString *)title
                               image: (NSString *)imageName
                       selectedImage: (NSString *)selectedImageName {
    
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:RGBCOLOR(85, 150, 229) forKey:NSForegroundColorAttributeName];
    [vc.tabBarItem setTitleTextAttributes:dict forState:UIControlStateSelected];
    
    [self addChildViewController:[[UINavigationController alloc] initWithRootViewController:vc]];
}

@end
