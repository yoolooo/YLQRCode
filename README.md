# YLQRCode
生成和扫描二维码的工具类
请在真机上运行，避免不必要的错误

使用：
导入YLQRCodeTool.h
生成二维码: + (UIImage *)QRCodeWithString:(NSString *)string;
识别图片二维码（默认图片中只有一个二维码）：+ (NSString *)detectQRCodeInImage:(UIImage *)image;
扫描：+ (QRCodeScanView *)QRCodeScanWithHandler:(SuccessHandler)handler;
  注：返回QRCodeScanView为摄像头预览，QRCodeScanView中有两个方法，开始和结束扫描，需要手动调用。
