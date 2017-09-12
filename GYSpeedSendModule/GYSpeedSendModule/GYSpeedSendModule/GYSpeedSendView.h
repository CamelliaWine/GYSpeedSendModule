//
//  GYShortcutPostPhotoView.h
//  截屏检测管理
//
//  Created by zl on 2017/9/8.
//  Copyright © 2017年 杭州京歌科技有限公司. All rights reserved.
//

#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#import <UIKit/UIKit.h>

typedef void(^GYButtonClickedBlock)(UIButton *sender, UIImage *image);

@interface GYSpeedSendView : UIView

/** 请使用此方法 创建 GYSpeedSendView 控件 */
- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image block:(GYButtonClickedBlock)block;

@end
