//
//  ScanViewController.m
//  makeCode
//
//  Created by cdv on 16/3/10.
//  Copyright © 2016年 yanlong. All rights reserved.
//

#import "ScanViewController.h"
#import "ScanFinishViewController.h"
#import "YLQRCodeTool.h"

@interface ScanViewController ()

@property (nonatomic, weak) QRCodeScanView *scanView;

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //注册权限失败通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authorizationDenied) name:YLQRCodeAuthorizationDeniedNotification object:nil];
    
    //扫描视图
    QRCodeScanView *scanView = [YLQRCodeTool QRCodeScanWithHandler:^(NSString *string) {
        
        //成功回调
        NSLog(@"%@",string);
        ScanFinishViewController *finishVC = [[ScanFinishViewController alloc] init];
        finishVC.string = string;
        [self.navigationController pushViewController:finishVC animated:YES];
    }];
    
    scanView.frame = self.view.bounds;
    [self.view addSubview:scanView];
    self.scanView = scanView;

}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    //打开扫描
    [self.scanView beginScan];
}

- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    [self.scanView stopScan];
}

- (void)authorizationDenied{
    
    NSLog(@"获取权限失败");
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
