//
//  GYSpeedSendButton.m
//  快捷发送模块
//
//  Created by zl on 2017/9/12.
//  Copyright © 2017年 山茶花酿酒. All rights reserved.
//

#import "GYSpeedSendButton.h"

@implementation GYSpeedSendButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.numberOfLines = 2;
        [self setTitle:@"你可能要发送的照片:" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat buttonWidth = self.frame.size.width;
    CGFloat buttonHeight = self.frame.size.height;
    
    self.titleLabel.frame = CGRectMake(5, 3, buttonWidth-10, 35);
    self.imageView.frame = CGRectMake(5, CGRectGetMaxY(self.titleLabel.frame)+3, buttonWidth-10, buttonHeight-CGRectGetMaxY(self.titleLabel.frame)-8);
}

@end
