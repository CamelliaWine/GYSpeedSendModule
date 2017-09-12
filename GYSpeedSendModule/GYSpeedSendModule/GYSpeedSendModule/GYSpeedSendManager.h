//
//  GYSpeedSendManager.h
//  GouGou
//
//  Created by 郑峥 on 2017/9/11.
//  Copyright © 2017年 金购中国. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static const CGFloat GYlimitTimeInterval = 10.0f;

/** 快捷发送照片状态 */
typedef NS_ENUM(NSInteger, GYSpeedSendStatus) {
    GYSpeedSendStatusSuccess = 0,
    GYSpeedSendStatusNoPhoto = 1,
    GYSpeedSendStatusTimeOut = 2,
    GYSpeedSendStatusHasPosted = 3,
    GYSpeedSendStatusVersionError = 4
};

typedef void(^GYReadPhotoBlock)(GYSpeedSendStatus status, UIImage *result);

@interface GYSpeedSendManager : NSObject

/** 快捷发送照片管理类单例 */
+ (instancetype)gy_manager;

/** 读取照片 */
- (void)gy_readPhoto:(GYReadPhotoBlock)block;

@end
