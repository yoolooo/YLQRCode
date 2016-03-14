//
//  ViewController.m
//  makeCode
//
//  Created by cdv on 16/3/10.
//  Copyright © 2016年 yanlong. All rights reserved.
//

#import "ViewController.h"
#import "ScanViewController.h"
#import "YLQRCodeTool.h"

@interface ViewController ()

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UITextField *textField;

@end

@implementation ViewController

- (IBAction)scan:(id)sender {
    
    [self.navigationController pushViewController:[ScanViewController new] animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 80, self.view.bounds.size.width-20, 30)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField = textField;
    [self.view addSubview:textField];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, CGRectGetMaxY(textField.frame)+20, self.view.bounds.size.width-20, 40);
    button.backgroundColor = [UIColor lightGrayColor];
    [button setTitle:@"生成二维码" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(qrCode) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(button.frame)+20, self.view.bounds.size.width-20, self.view.bounds.size.width-20)];
    imageView.backgroundColor = [UIColor lightGrayColor];
    self.imageView = imageView;
    [self.view addSubview:imageView];
 
    //生成二维码
    imageView.image = [YLQRCodeTool QRCodeWithString:@"闫龙-闫某某"];
    
}

- (void)qrCode{

    if (self.textField.text.length == 0) {
        return;
    }
    self.imageView.image = [YLQRCodeTool QRCodeWithString:self.textField.text];
    [self.view endEditing:YES];
}




@end
