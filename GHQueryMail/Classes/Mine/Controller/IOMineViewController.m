//
//  IOMineViewController.m
//  GHQueryMail
//
//  Created by zhaozhiwei on 2019/5/10.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import "IOMineViewController.h"
#import "IOMineCell.h"
#import "Header.h"
#import "IOMineHeader.h"
#import "IOHistoryViewController.h"
#import "IOLoginViewController.h"
#import "IOChangePasswordViewController.h"
#import "IOSuggestViewController.h"
#import "GHActivity.h"
#import <Social/Social.h>
#import "SDImageCache.h"
#import <AVOSCloud/AVOSCloud.h>

@interface IOMineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) IOMineHeader *header;

@end

@implementation IOMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.navigationItem.title = @"个人中心";
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.header;

}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.01f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ?1:4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IOMineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IOMineCellID"];
    cell.indexPath = indexPath;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [self jumpHistory];
                break;
            default:
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0:
                [self clearDisk];
                break;
            case 1:
                [self jumpChangePassword];
                break;
            case 2:
                [self jumpSuggest];
                break;
            case 3:
                [self share];
                break;
            default:
                break;
        }
    }
}

- (void)clearDisk {
    [[SDImageCache sharedImageCache] clearMemory];
    [self.tableView reloadData];
}

- (void)share {
    // 1、设置分享的内容，并将内容添加到数组中
    NSString *shareText = @"分享的标题";
    //        UIImage *shareImage = [UIImage imageNamed:@"shareImage.png"];
    NSURL *shareUrl = [NSURL URLWithString:@"https://www.jianshu.com/u/15d37d620d5b"];
    NSArray *activityItemsArray = @[shareText,shareUrl];
    
    // 自定义的CustomActivity，继承自UIActivity
    GHActivity *customActivity = [[GHActivity alloc]initWithTitle:shareText activityImage:nil url:shareUrl activityType:@"Custom"];
    
    
    // 1、设置分享的内容，并将内容添加到数组中
    NSString *shareText0 = @"qqq分享的标题";
    //        UIImage *shareImage = [UIImage imageNamed:@"shareImage.png"];
    NSURL *shareUrl0 = [NSURL URLWithString:@"https://www.jianshu.com/u/15d37d620d5bwwww"];
    NSArray *activityItemsArray0 = @[shareText,shareUrl,shareText0,shareUrl0];
    
    // 自定义的CustomActivity，继承自UIActivity
    GHActivity *customActivity0 = [[GHActivity alloc]initWithTitle:shareText0 activityImage:nil url:shareUrl0 activityType:@"Custom"];
    
    
    NSArray *activityArray = @[customActivity,customActivity0];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItemsArray0 applicationActivities:activityArray];
    
    // 2、初始化控制器，添加分享内容至控制器
    activityVC.modalInPopover = YES;
    // 3、设置回调
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // ios8.0 之后用此方法回调
        UIActivityViewControllerCompletionWithItemsHandler itemsBlock = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
            NSLog(@"activityType == %@",activityType);
            if (completed == YES) {
                NSLog(@"completed");
            }else{
                NSLog(@"cancel");
            }
        };
        activityVC.completionWithItemsHandler = itemsBlock;
    }else{
        // ios8.0 之前用此方法回调
        UIActivityViewControllerCompletionHandler handlerBlock = ^(UIActivityType __nullable activityType, BOOL completed){
            NSLog(@"activityType == %@",activityType);
            if (completed == YES) {
                NSLog(@"completed");
            }else{
                NSLog(@"cancel");
            }
        };
        activityVC.completionHandler = handlerBlock;
    }
    // 4、调用控制器
    [self presentViewController:activityVC animated:YES completion:nil];
}
- (void)jumpSuggest {
    IOSuggestViewController *vc = [[IOSuggestViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpChangePassword {
    IOChangePasswordViewController *vc = [[IOChangePasswordViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpHistory {
    IOHistoryViewController *vc = [[IOHistoryViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IOMineHeader *)header {
    if (_header == nil) {
        _header = [[IOMineHeader alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
        weakself(self);
        _header.didClickBlock = ^{
            IOLoginViewController *vc = [[IOLoginViewController alloc]init];
            [weakSelf presentViewController:vc animated:YES completion:nil];
        };
    }
    return _header;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
     _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kTabBarHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[IOMineCell class] forCellReuseIdentifier:@"IOMineCellID"];
    }
    return _tableView;
}

@end
