//
//  YLQRCodeTool.h
//  YLQRCode
//
//  Created by cdv on 16/3/10.
//  Copyright © 2016年 yanlong. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  获取摄像头权限失败通知
 */
static NSString *const YLQRCodeAuthorizationDeniedNotification = @"AuthorizationStatusDenied";

static NSString *const YLQRCodeError = @"YLQRCodeError";

typedef void (^SuccessHandler) (NSString * string);

@interface QRCodeScanView : UIView

/**
 *  开始扫描
 */
- (void)beginScan;


/**
 *  停止扫描
 */
- (void)stopScan;

@end


@interface YLQRCodeTool : NSObject


/**
 *  生成二维码图片
 *
 *  @param string 二维码内容
 *
 *  @return 二维码图片
 */
+ (UIImage *)QRCodeWithString:(NSString *)string;


/**
 *  扫描二维码
 *
 *  @param handel 扫描成功回调
 *
 *  @return 摄像头图像预览
 */
+ (QRCodeScanView *)QRCodeScanWithHandler:(SuccessHandler)handler;


/**
 *  识别图片中的二维码
 *
 *  @param image 图片
 *
 *  @return 识别内容
 */
+ (NSString *)detectQRCodeInImage:(UIImage *)image;

@end
