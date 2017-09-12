//
//  GYShowViewController.m
//  快捷发送模块
//
//  Created by zl on 2017/9/12.
//  Copyright © 2017年 山茶花酿酒. All rights reserved.
//

#import "GYShowViewController.h"
#import "GYSpeedSendView.h"

@interface GYShowViewController ()

@end

@implementation GYShowViewController

+ (void)presentFrom:(UIViewController *)viewController image:(UIImage *)image completion:(void (^)())completion finish:(void (^)())finish
{
    GYShowViewController *vc = [[self alloc] init];
    
    GYSpeedSendView *photoView = [[GYSpeedSendView alloc] initWithFrame:vc.view.bounds image:image block:^(UIButton *sender, UIImage *image) {
        
        if (sender.tag==10) {//发送
            [vc dismissViewControllerAnimated:YES completion:^{
                finish();
            }];
            
        } else if (sender.tag==11) {//返回
            [vc dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    [vc.view addSubview:photoView];
    [viewController presentViewController:vc animated:YES completion:completion];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
