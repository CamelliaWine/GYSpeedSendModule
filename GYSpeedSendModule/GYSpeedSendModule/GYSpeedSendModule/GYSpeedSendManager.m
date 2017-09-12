//
//  GYSpeedSendManager.m
//  GouGou
//
//  Created by 郑峥 on 2017/9/11.
//  Copyright © 2017年 金购中国. All rights reserved.
//

#import "GYSpeedSendManager.h"
#import <Photos/Photos.h>
#import "PHAsset+GYAsset.h"

@interface GYSpeedSendManager ()

/** 相册资源获取参数 */
@property (nonatomic, strong) PHFetchOptions *fetchOptions;
/** 最后一项PHAsst */
@property (nonatomic, strong) NSString *lastAssetID;

@end

@implementation GYSpeedSendManager

+ (instancetype)gy_manager
{
    static GYSpeedSendManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

/**
 PHAssetCollectionTypeAlbum：用户自建相册集合
 PHAssetCollectionTypeMoment：标题为“时刻”时的相册集合
 PHAssetCollectionTypeSmartAlbum：系统自建相册 eg:相机胶卷、地点、最近删除、Live Photo、视频等。（外加“年度”、“精选”？？？）
 */

/**
 PHAssetCollectionSubtypeSmartAlbumUserLibrary：相机胶卷，所有相机拍摄的照片或视频都会出现在该相册中，而且使用其他应用保存的照片也会出现在这里
 */
- (void)gy_readPhoto:(GYReadPhotoBlock)block
{
#ifndef __IPHONE_8_0
    
    block(GYSpeedSendStatusVersionError, nil);//版本错误
    
#else
    
    PHFetchResult *assetCollectionResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    if (assetCollectionResult.count==0) {
        block(GYSpeedSendStatusNoPhoto, nil);//无相册
        NSLog(@"GYSpeedSendManager - 无相册");
        return;
    }
    
    PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:assetCollectionResult[0] options:self.fetchOptions];
    if (assetResult.count==0) {
        block(GYSpeedSendStatusNoPhoto, nil);//有相册无照片
        NSLog(@"GYSpeedSendManager - 有相册无照片");
        return;
    }
    
    PHAsset *asset = assetResult.lastObject;
    asset.assetID = [NSString stringWithFormat:@"%lu", (unsigned long)assetResult.count];
    NSLog(@"GYSpeedSendManager - %@", asset.assetID);
    NSTimeInterval currentTimeInterval = [NSDate.date timeIntervalSince1970];
    NSTimeInterval photoTimeInterval = [asset.creationDate timeIntervalSince1970];
    NSTimeInterval space = currentTimeInterval - photoTimeInterval;
    
    if (space > GYlimitTimeInterval) {
        block(GYSpeedSendStatusTimeOut, nil);//有照片但超时
        NSLog(@"GYSpeedSendManager - 有照片但超时");
        return;
    }
    
    
    if ([asset.assetID isEqualToString:self.lastAssetID]) {
        block(GYSpeedSendStatusHasPosted, nil);//未超时但已经发送过
        NSLog(@"GYSpeedSendManager - 未超时但已经发送过");
        return;
    }
    
    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    
    PHImageManager *manager = [PHImageManager defaultManager];
    [manager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        block(GYSpeedSendStatusSuccess, result);
        NSLog(@"GYSpeedSendManager - 成功");
    }];
    
    self.lastAssetID = asset.assetID;
    
#endif
    
}

- (PHFetchOptions *)fetchOptions
{
    if (_fetchOptions==nil) {
        
        _fetchOptions = [[PHFetchOptions alloc] init];
        /** 只获取图片 */
        _fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d",PHAssetMediaTypeImage];
        /** 按照时间升序排序 */
        _fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    }
    return _fetchOptions;
}

@end
