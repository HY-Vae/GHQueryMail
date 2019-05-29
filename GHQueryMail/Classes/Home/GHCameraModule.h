//
//  GHCameraModule.h
//  GHCameraModuleDemo
//
//  Created by mac on 2018/11/23.
//  Copyright © 2018年 GHome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class GHCameraModuleModel;
NS_ASSUME_NONNULL_BEGIN

typedef void (^CameraModuleBlock)(NSDictionary *info);
typedef void (^CameraModuleCodeBlock)(NSString *resultString);
typedef void (^CameraModuleFlashlightBlock)(BOOL on);

/** 摄像头类型 */
typedef NS_ENUM (NSUInteger,GHCameraModuleType) {
    /** 相机 */
    GHCameraModuleTypeCamera,
    /** 扫一扫 */
    GHCameraModuleTypeScan,
};

@class GHCameraModule;
@protocol GHCameraModuleDelegate <NSObject>

/**
 相机模块图片选择回调 (相机,相册)
 
 @param cameraModule cameraModule
 @param image image
 */
- (void)cameraModule:(GHCameraModule *)cameraModule image:(UIImage *)image;

/**
 相机模块二维码回调
 
 @param cameraModule cameraModule
 @param resultString resultString
 */
- (void)cameraModule:(GHCameraModule *)cameraModule resultString:(nullable NSString *)resultString;

@end

@interface GHCameraModule : NSObject
#pragma mark - ios9之后调用相机.需要在info中 添加 NSCameraUsageDescription
/**
 构造方法
 
 @param cameraModuleBlock 选择图片回调
 @param cameraModuleCodeBlock 二维码回调
 @return GHCameraModule
 */
- (instancetype)creatCameraModuleWithCameraModuleBlock: (CameraModuleBlock)cameraModuleBlock
                                 cameraModuleCodeBlock: (CameraModuleCodeBlock)cameraModuleCodeBlock;
/** 二维码扫描区域 */
@property (nonatomic , assign) CGRect rectOfInterest;
@property (nonatomic , copy) CameraModuleFlashlightBlock flashlightBlock;

/** 打开摄像头 */
- (void)start;
/** 关闭摄像头 */
- (void)stop;
/** 屏幕截图 */
- (void)screenshot;
/** 打开关闭手电筒 */
- (BOOL)turnTorchOn:(BOOL)on;
/** 选择相册 */
- (void)chosePhoto ;
/** 调整镜头焦距 */
- (void)adjustFocalWtihValue: (CGFloat)value;

- (void)testWithPoint: (CGPoint)point;

@property (nonatomic , strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic , weak) id <GHCameraModuleDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

