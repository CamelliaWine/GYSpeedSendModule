//
//  GYShortcutPostPhotoView.m
//  截屏检测管理
//
//  Created by zl on 2017/9/8.
//  Copyright © 2017年 杭州京歌科技有限公司. All rights reserved.
//

#import "GYSpeedSendView.h"

@interface GYSpeedSendView () <UIScrollViewDelegate>

/** 底部scrollView */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 图片 */
@property (nonatomic, strong) UIImageView *imageView;
/** 顶部栏 */
@property (nonatomic, strong) UIView *topView;
/** 底部栏 */
@property (nonatomic, strong) UIView *botttomView;
/** 发送按钮 */
@property (nonatomic, strong) UIButton *sendButton;
/** 返回按钮 */
@property (nonatomic, strong) UIButton *backButton;
/** 发送\返回按钮回调 */
@property (nonatomic, copy) GYButtonClickedBlock block;
/** 原图 */
@property (nonatomic, strong) UIImage *image;

@end

@implementation GYSpeedSendView

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image block:(GYButtonClickedBlock)block
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.imageView];
        [self addSubview:self.topView];
        [self addSubview:self.botttomView];
        [self addSubview:self.sendButton];
        [self addSubview:self.backButton];
        [self zoomImageWithOriginalImage:image block:^(UIImage *newImage, CGRect imageViewFrame) {
            self.imageView.image = newImage;
            self.imageView.frame = imageViewFrame;
        }];
        
        self.block = block;
        self.image = image;
        
    }
    return self;
}

#pragma mark - UI
- (UIScrollView *)scrollView
{
    if (_scrollView==nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.minimumZoomScale = 1;
        _scrollView.maximumZoomScale = 5;
        _scrollView.zoomScale = 1;
    }
    return _scrollView;
}
- (UIImageView *)imageView
{
    if (_imageView==nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor blackColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}
- (UIView *)topView
{
    if (_topView==nil) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 64)];
        _topView.backgroundColor = [UIColor blackColor];
        _topView.alpha = 0.7;
    }
    return _topView;
}
- (UIView *)botttomView
{
    if (_botttomView==nil) {
        
        _botttomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-49, self.bounds.size.width, 49)];
        _botttomView.backgroundColor = [UIColor blackColor];
        _botttomView.alpha = 0.7;
    }
    return _botttomView;
}
- (UIButton *)sendButton
{
    if (_sendButton==nil) {
        
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.frame = CGRectMake(self.bounds.size.width-56-20, (CGRectGetHeight(self.topView.frame)-20-31)/2+20, 56, 31);
//        [_sendButton setBackgroundImage:[UIImage imageNamed:@"fasonganniu_png"] forState:UIControlStateNormal];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _sendButton.layer.cornerRadius = 3;
        _sendButton.layer.masksToBounds = YES;
        _sendButton.backgroundColor = [UIColor colorWithRed:0.96 green:0.16 blue:0.18 alpha:1.00];
        [_sendButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _sendButton.tag = 10;
    }
    return _sendButton;
}

- (UIButton *)backButton
{
    if (_backButton==nil) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(20, (CGRectGetHeight(self.topView.frame)-20-30)/2+20, 30, 30);
//        [_backButton setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _backButton.tag = 11;
    }
    return _backButton;
}

#pragma mark - 事件交互
- (void)buttonClicked:(UIButton *)sender
{
    if (self.block) {
        self.block(sender, self.image);
    }
}

#pragma mark - 根据原图按照缩放比例生成一张新图
- (void)zoomImageWithOriginalImage:(UIImage *)originalImage block:(void (^)(UIImage *newImage, CGRect imageViewFrame))block
{
    if (originalImage==nil) {
        block(nil, CGRectZero);
        return;
    }
    
    //原图尺寸
    CGSize  originalSize   = originalImage.size;
    CGFloat originalWidth  = originalSize.width;
    CGFloat originalHeight = originalSize.height;
    CGFloat ratio = originalWidth/originalHeight;
    
    //目标imageView尺寸
    CGFloat targetWidth  = ScreenWidth;
    CGFloat targetHeight = targetWidth/ratio;
    CGSize  targetSize   = CGSizeMake(targetWidth, targetHeight);
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaleWidth = targetWidth;
    CGFloat scaleHeight = targetHeight;
    CGPoint scalePoint = CGPointMake(0.0, 0.0);
    
    if (CGSizeEqualToSize(originalSize, targetSize)==NO) {
        
        CGFloat widthFactor = targetWidth / originalWidth;
        CGFloat heightFactor = targetHeight / originalHeight;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }else{
            scaleFactor = heightFactor;
        }
        scaleWidth = originalWidth * scaleFactor;
        scaleHeight = originalHeight * scaleFactor;
        
        if(widthFactor > heightFactor){
            scalePoint.y = (targetHeight - scaleHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            scalePoint.x = (targetWidth - scaleWidth) * 0.5;
        }
    }
    
    //重绘
    UIImage *targetImage = nil;
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0);
    CGRect drawRect = CGRectZero;
    drawRect.origin = scalePoint;
    drawRect.size.width = scaleWidth;
    drawRect.size.height = scaleHeight;
    [originalImage drawInRect:drawRect];
    targetImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGFloat temp = targetImage.size.height;
    if (temp>=ScreenHeight) {
        temp = ScreenHeight;
    }
    block(targetImage, CGRectMake(0, (ScreenHeight-temp)*0.5, targetWidth, temp));
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    NSLog(@"%f - %f", scrollView.contentSize.width, scrollView.contentSize.height);
    
    CGFloat offset_x = (scrollView.contentSize.width > scrollView.bounds.size.width)? 0 : (scrollView.bounds.size.width - scrollView.contentSize.width)*0.5;
    CGFloat offset_y = (scrollView.contentSize.height > scrollView.bounds.size.height)? 0 : (scrollView.bounds.size.height - scrollView.contentSize.height)*0.5;
    self.imageView.center = CGPointMake(scrollView.contentSize.width*0.5+offset_x, scrollView.contentSize.height*0.5+offset_y);
}
//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
//{
//    NSLog(@"%s - %f", __func__, scale);
//}



- (void)dealloc
{
    NSLog(@"%s", __func__);
}






@end
