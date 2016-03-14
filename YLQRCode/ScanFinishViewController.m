//
//  ScanFinishViewController.m
//  makeCode
//
//  Created by cdv on 16/3/10.
//  Copyright © 2016年 yanlong. All rights reserved.
//

#import "ScanFinishViewController.h"

@interface ScanFinishViewController ()

@end

@implementation ScanFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UITextView *textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    textView.text = self.string;
    [self.view addSubview:textView];
    
}

@end
