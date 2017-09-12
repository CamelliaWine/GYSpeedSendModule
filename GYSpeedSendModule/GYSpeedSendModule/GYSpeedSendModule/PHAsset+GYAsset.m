
//
//  PHAsset+GYAsset.m
//  截屏检测管理
//
//  Created by zl on 2017/9/11.
//  Copyright © 2017年 杭州京歌科技有限公司. All rights reserved.
//

#import "PHAsset+GYAsset.h"
#import <objc/runtime.h>

static const void *kAssetID = @"0";

@implementation PHAsset (GYAsset)

- (void)setAssetID:(NSString*)assetID
{
    objc_setAssociatedObject(self, kAssetID, assetID, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)assetID
{
    return objc_getAssociatedObject(self, kAssetID);
}








@end
