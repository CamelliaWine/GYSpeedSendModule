//
//  GYShowViewController.h
//  快捷发送模块
//
//  Created by zl on 2017/9/12.
//  Copyright © 2017年 山茶花酿酒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYShowViewController : UIViewController

+ (void)presentFrom:(UIViewController *)viewController image:(UIImage *)image completion:(void (^)())completion finish:(void (^)())finish;

@end
