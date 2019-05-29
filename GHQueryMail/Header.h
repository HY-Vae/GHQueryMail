//
//  Header.h
//  GHQueryMail
//
//  Created by zhaozhiwei on 2019/4/23.
//  Copyright © 2019年 GHome. All rights reserved.
//

#ifndef Header_h
#define Header_h

/**
 头文件说明：
 1、与设备有关的宏定义
 */
#pragma mark - *************************  block弱引用强引用  *************************
//弱引用对象
#define WS(weakSelf)            __weak __typeof(&*self)weakSelf = self;
// WeakSelf
#define weakself(self)          __weak __typeof(self) weakSelf = self
//强引用对象
#define StrongSelf(strongSelf)  __strong __typeof(&*weakSelf)strongSelf = weakSelf;


// Rete
#define kScreenWidthRete   kScreenWidth / 375.0 //比率
#define kScreenHeightRete  kScreenWidth / 667.0 //比率
// AutoSize
#define kAutoWithSize(r) r * kScreenWidth / 375.0
#define kFont(size) kAutoWithSize(size)

#define kAutoHeightSize(r) r * kScreenHeight / 667.0


#pragma mark - *************************  硬件相关  *************************
#define kCuttingLineHeight          ([[UIScreen mainScreen] scale] == 2.f ? 0.5 : 0.34) //分割线高度
#define kNavHeight                  kSafeAreaTopHeight       //导航的高度
#define kSafeAreaBottomHeight       (IS_PhoneXAll ? 34 : 0)
// StatusbarH + NavigationH
#define kSafeAreaTopHeight          (IS_PhoneXAll ? 88.f : 64.f)
// StatusBarHeight
#define kStatusBarHeight            (IS_PhoneXAll ? 44.f : 20.f)
// NavigationBarHeigth
#define                             kNavBarHeight 44.f
// TabBarHeight
#define kTabBarHeight               (IS_PhoneXAll ? (49.f+34.f) : 49.f)

//顶部间隙：iPhoneX 的界面不显示状态栏：44，其他屏幕0
#define kJZGHeight_TopSpace         (iPhoneX ? 44.0f : 0)
//底部间隙：iPhoneX 的界面要向上提34
#define kJZGHeight_BottomSpace      (iPhoneX ? 34.0f : 0)

/** 获取屏幕尺寸、宽度、高度 */
#define kScreenRect                 ([[UIScreen mainScreen] bounds])            //屏幕frame
#define kScreenSize                 ([UIScreen mainScreen].bounds.size)         //屏幕size
#define kScreenWidth                ([UIScreen mainScreen].bounds.size.width)   //屏幕宽度
#define kScreenHeight               ([UIScreen mainScreen].bounds.size.height)  //屏幕高度
#define kScreenScale                ([[UIScreen mainScreen] scale])             //缩放系数
#define kScreenCurrModeSize         [[UIScreen mainScreen] currentMode].size    //currentModel的size

#define kScreenMaxLength            (MAX(kScreenWidth, kScreenHeight))          //获取屏幕宽高最大者
#define kScreenMinLength            (MIN(kScreenWidth, kScreenHeight))          //获取屏幕宽高最小者

#define isIPad                      (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)    //是否是ipad设备
#define isIPhone                    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)  //是否是iPhone设备
#define isRetina                    (kScreenScale >= 2.0)                                     //是否是retina屏幕

//是否是垂直
#define isPortrait                  ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)

//UIScreen是否响应currentMode方法
#define isRespondCurrModel          [UIScreen instancesRespondToSelector:@selector(currentMode)]
#define isEqualToCurrModelSize(w,h) CGSizeEqualToSize(CGSizeMake(w,h), kScreenCurrModeSize)

/** 设备是否为iPhone 4/4S 分辨率320x480，像素640x960，@2x */
#define iPhone4                     (isRespondCurrModel ? isEqualToCurrModelSize(640,960) : NO)

/** 设备是否为iPhone 5C/5/5S 分辨率320x568，像素640x1136，@2x */
#define iPhone5                     (isRespondCurrModel ? isEqualToCurrModelSize(640,1136) : NO)

/** 设备是否为iPhone 6 分辨率375x667，像素750x1334，@2x */
#define iPhone6                     (isRespondCurrModel ? isEqualToCurrModelSize(750, 1334) || isEqualToCurrModelSize(640, 1136) : NO)

/** 设备是否为iPhone 6 Plus 分辨率414x736，像素1242x2208，@3x */
#define iPhone6Plus                 (isRespondCurrModel ? isEqualToCurrModelSize(1125, 2001) || isEqualToCurrModelSize(1242, 2208) : NO)

#define iPhone6PlusZoom             (isRespondCurrModel ? isEqualToCurrModelSize(1125, 2001) : NO)

/*设备是否为iPhone X 分辨率375x812，像素1125x2436，@3x*/
#define iPhoneX                     (isRespondCurrModel ? isEqualToCurrModelSize(1125, 2436) : NO)

//自动调整x、y比例
#define AutoSizeScaleForX (kScreenWidth > 480 ? kScreenWidth/320 : 1.0)
#define AutoSizeScaleForY (kScreenHeight > 480 ? kScreenHeight/568 : 1.0)

#pragma mark - *************************  系统相关  *************************
// AppDelegate
#define kAppDelegate            ((AppDelegate *)[[UIApplication sharedApplication] delegate])
// KeyWindow
#define kKeyWindow              kAppDelegate.window

/** 获取系统版本 */
#define kSystemVersionString    ([[UIDevice currentDevice] systemVersion])
#define kSystemVersion          ([[[UIDevice currentDevice] systemVersion] floatValue])

/** 获取APP名称 */
#define kAppName                ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"])
/** 获取APP版本 */
#define kAppVersion             ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])
/** 获取APP build版本 */
#define kAppBuildVersion        ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"])
/** 应用appScheme */
#define kAppScheme              @"FangShengYunCai"

/** 是否为iOS6、7、8、9、10系统 */
#define iOS6                    ((kSystemVersion >= 6.0) ? YES : NO)
#define iOS7                    ((kSystemVersion >= 7.0) ? YES : NO)
#define iOS8                    ((kSystemVersion >= 8.0) ? YES : NO)
#define iOS9                    ((kSystemVersion >= 9.0) ? YES : NO)
#define iOS10                   ((kSystemVersion >= 10.0) ? YES : NO)



#pragma mark - *************************  本地文档相关  *************************
/** 获取Documents目录 */
#define kDocumentsPath          ([NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject])

/** 获得Documents下指定文件名的文件路径 */
#define kFilePath(filename)     ([[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:filename])


#pragma mark - *************************  原设备配置相关  *************************

#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

#define ISIPAD [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad

#define ISIPHONE [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone

#define ISIPHONE4 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )480) < DBL_EPSILON )

#define ISIPHONE5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )568) < DBL_EPSILON )

#define ISIPHONE6 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )667) < DBL_EPSILON )

#define ISIPHONE6PLUS (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )960) < DBL_EPSILON )


#define ISIOSVERSION floorf([[UIDevice currentDevice].systemVersion floatValue]

#define ISIOS5 floorf([[UIDevice currentDevice].systemVersion floatValue]) == 5.0 ? 1 : 0

#define ISIOS6  floorf([[UIDevice currentDevice].systemVersion floatValue]) == 6.0 ? 1 : 0

#define ISIOS7 floorf([[UIDevice currentDevice].systemVersion floatValue]) ==7.0 ? 1 : 0

#define ISIOS8 floorf([[UIDevice currentDevice].systemVersion floatValue]) == 8.0 ? 1 : 0

#define ISIOS9 floorf([[UIDevice currentDevice].systemVersion floatValue]) == 9.0 ? 1 : 0

#define ISIOS10 floorf([[UIDevice currentDevice].systemVersion floatValue]) == 10.0 ? 1 : 0

#define ISIOS11 floorf([[UIDevice currentDevice].systemVersion floatValue]) == 11.0 ? 1 : 0

#define ISIOS12 floorf([[UIDevice currentDevice].systemVersion floatValue]) == 12.0 ? 1 : 0


//判断是否是ipad
#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//判断iPhone4系列
#define kiPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhone5系列
#define kiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhone6 6s 7系列
#define kiPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iphone6p 6sp 7p系列
#define kiPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneX序列（iPhoneX，iPhoneXs，iPhoneXs Max）
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPHoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

//判断iPHoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

//判断iPhoneXsMax
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size)&& !isPad : NO)

//判断iPhoneX所有系列

#define IS_PhoneXAll \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})


#define k_Height_NavContentBar 44.0f
#define k_Height_StatusBar (IS_PhoneXAll? 44.0 : 20.0)
#define k_Height_NavBar (IS_PhoneXAll ? 88.0 : 64.0)
#define k_Height_TabBar (IS_PhoneXAll ? 83.0 : 49.0)
#define RGBACOLOR(r,g,b,a)              [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define RGBCOLOR(r,g,b)                 RGBACOLOR(r,g,b,1.0f)

#endif /* Header_h */
