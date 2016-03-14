//
//  YLQRCodeTool.m
//  YLQRCode
//
//  Created by cdv on 16/3/10.
//  Copyright © 2016年 yanlong. All rights reserved.
//

#import "YLQRCodeTool.h"

@interface QRCodeScanView () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, copy) SuccessHandler handler;
@property (nonatomic, strong) dispatch_queue_t queue;

@end


@implementation QRCodeScanView

+ (Class)layerClass{

    return [AVCaptureVideoPreviewLayer class];
}

- (void)setSession:(AVCaptureSession *)session{
    
    _session = session;
    [(AVCaptureVideoPreviewLayer *)self.layer setSession:session];
}

- (dispatch_queue_t)queue{

    if (!_queue) {
        self.queue = dispatch_queue_create("com.yoolooo.scan", NULL);
    }
    return _queue;
}

- (instancetype)initWithSuccessHandler:(SuccessHandler)handler{

    if (self = [super init]) {
        self.handler = handler;
        self.session = [[AVCaptureSession alloc] init];
        [self addInput];
    }
    return self;
}

- (void)addInput{
    
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    if ([self.session canAddInput:videoInput]) {
        [self.session addInput:videoInput];
    }
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusAuthorized) {
        [self addOutput];
    }else if (status == AVAuthorizationStatusDenied){
        [[NSNotificationCenter defaultCenter] postNotificationName:YLQRCodeAuthorizationDeniedNotification object:nil userInfo:nil];
    }else{
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted == YES) {
                [self addOutput];
            }
        }];
    }
}

- (void)addOutput{
    
    AVCaptureMetadataOutput *metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    if ([self.session canAddOutput:metadataOutput]) {
        [self.session addOutput:metadataOutput];
        if (self.device.autoFocusRangeRestrictionSupported) {
            NSError *error;
            [self.device lockForConfiguration:&error];
            self.device.autoFocusRangeRestriction = AVCaptureAutoFocusRangeRestrictionNear;
            [self.device unlockForConfiguration];
        }
        [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        metadataOutput.metadataObjectTypes = @[AVMetadataObjectTypeAztecCode,AVMetadataObjectTypeQRCode,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeInterleaved2of5Code,AVMetadataObjectTypeITF14Code];
        
    }else{
        NSLog(@"添加输出失败");
        [[NSNotificationCenter defaultCenter] postNotificationName:YLQRCodeError object:nil];
    }
}

- (void)beginScan{
    
    dispatch_async(self.queue, ^{
        [self.session startRunning];
    });
}

- (void)stopScan{
    
    dispatch_async(self.queue, ^{
    [self.session stopRunning];
});

}

#pragma mark -- AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *codeObject = [metadataObjects firstObject];
        if (self.handler) {
            self.handler(codeObject.stringValue);
            [self stopScan];
        }
    }
}

@end



#pragma mark -- YLQRCodeTool

@implementation YLQRCodeTool

+ (UIImage *)QRCodeWithString:(NSString *)string{
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    CIImage *ciImage = [filter outputImage];
    UIImage *image = [UIImage imageWithCIImage:ciImage];
    
    UIImage *highImage = nil;
    CGFloat width = image.size.width * 10;
    CGFloat height = image.size.height * 10;
    CGInterpolationQuality quality = kCGInterpolationNone;
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, quality);
    [image drawInRect:CGRectMake(0, 0, width, height)];
    highImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return highImage;
}

+ (QRCodeScanView *)QRCodeScanWithHandler:(SuccessHandler)handler{
    
    QRCodeScanView *scan = [[QRCodeScanView alloc] initWithSuccessHandler:handler];
    return scan;
}

+ (NSString *)detectQRCodeInImage:(UIImage *)image{

    NSDictionary *options = @{CIDetectorAccuracy:CIDetectorAccuracyHigh};
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:options];
    CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
    NSArray *features = [detector featuresInImage:ciImage];
    if (features.count > 0) {
        CIQRCodeFeature *code = [features firstObject];
        return code.messageString;
    }
    return nil;
}

@end
