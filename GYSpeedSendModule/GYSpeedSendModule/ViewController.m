//
//  ViewController.m
//  GYSpeedSendModule
//
//  Created by zl on 2017/9/12.
//  Copyright © 2017年 山茶花酿酒. All rights reserved.
//

#import "ViewController.h"
#import "GYSpeedSendManager.h"
#import "GYSpeedSendButton.h"
#import "GYShowViewController.h"

@interface ViewController ()

@end

@implementation ViewController

/**
 * 注意：
 * 1、版本适配在iOS8.0以上
 * 2、在info.plist文件中 加入：key：NSPhotoLibraryUsageDescription， value：任意字符串
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 100, 100);
    button.backgroundColor = [UIColor colorWithRed:0.96 green:0.16 blue:0.18 alpha:1.00];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonClicked:(UIButton *)sender
{
    /** 创建快捷发送图片管理类 succes的时候拿到符合条件的照片 创建显示该照片的小按钮 */
    [[GYSpeedSendManager gy_manager] gy_readPhoto:^(GYSpeedSendStatus status, UIImage *result) {
        
        if (status == GYSpeedSendStatusSuccess) {
            
            GYSpeedSendButton *sendButton = [[GYSpeedSendButton alloc] init];
            sendButton.frame = CGRectMake(100, 300, 100, 150);
            [sendButton setImage:result forState:UIControlStateNormal];
            [sendButton addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:sendButton];
        }
    }];
}

- (void)sendButtonClicked:(GYSpeedSendButton *)sender
{
    /** present 进入显示大图的控制器 */
    [GYShowViewController presentFrom:self image:sender.currentImage completion:^{
        [sender removeFromSuperview];
    } finish:^{
        NSLog(@"GYShowViewController 点击发送按钮 回调到此");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
