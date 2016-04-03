//
//  TurntableView.m
//  20160402001-CoreAnimation-Turntable
//
//  Created by Rainer on 16/4/2.
//  Copyright © 2016年 Rainer. All rights reserved.
//

#import "TurntableView.h"
#import "LuckyRotateButton.h"

#define angle2Radion(angle) ((angle) / 180.0 * M_PI)
#define kButtonCount 12
#define kButtonW 68
#define kButtonH 143

@interface TurntableView ()

@property (weak, nonatomic) IBOutlet UIImageView *luckyRotateWheelImageView;
@property (weak, nonatomic) IBOutlet UIButton *beginChangeNumberButton;
@property (weak, nonatomic) LuckyRotateButton *luckyRotateButton;
@property (strong, nonatomic) CADisplayLink *displayLink;

@end

@implementation TurntableView

/**
 *  快速创建一个转盘对象
 */
+ (instancetype)turntableView {
    return [[[NSBundle mainBundle] loadNibNamed:@"TurntableView" owner:self options:nil] lastObject];
}

/**
 *  从xib中加载视图
 */
- (void)awakeFromNib {
    // 1.设置当前转盘视图可交互
    self.luckyRotateWheelImageView.userInteractionEnabled = YES;
    
    // 2.获取转盘按钮显示星座原始图片
    UIImage *oldImageNomal = [UIImage imageNamed:@"LuckyAstrology"];
    UIImage *oldImageSelected = [UIImage imageNamed:@"LuckyAstrologyPressed"];
    
    // 获取当前屏幕像素点的比例
    CGFloat scale = [UIScreen mainScreen].scale;
    
    CGFloat newImageW = oldImageNomal.size.width * scale / 12;
    CGFloat newImageH = oldImageNomal.size.height * scale;
    
    // 2.循环添加12星座对应的按钮
    for (int i = 0; i < kButtonCount; i++) {
        // 2.1.创建一个自定义按钮对象
        LuckyRotateButton *button = [LuckyRotateButton buttonWithType:UIButtonTypeCustom];
        
        // 2.2.获取当前转盘图片的宽高
        CGFloat imageViwWH = self.bounds.size.width;
        
        // 2.3.设置转盘layer层的位置
        button.layer.position = CGPointMake(imageViwWH * 0.5, imageViwWH * 0.5);
        // 2.4.设置转盘layer层的锚点
        button.layer.anchorPoint = CGPointMake(0.5, 1);
        // 2.5.设置按钮的大小位置
        button.bounds = CGRectMake(0, 0, kButtonW, kButtonH);
        // 2.6.设置按钮的背景图片
        [button setBackgroundImage:[UIImage imageNamed:@"LuckyRototeSelected"] forState:UIControlStateSelected];
        // 2.7.给按钮添加点击事件
        [button addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchDown];
        
        // 2.8.获取每个按钮对象的旋转的角度
        CGFloat radion = angle2Radion(30 * i);
        
        // 2.9.设置按钮旋转
        button.transform = CGAffineTransformMakeRotation(radion);
        
        // 计算图片的裁剪区域
        CGRect newImageRect = CGRectMake(newImageW * i, 0, newImageW, newImageH);
        
        // 开始裁剪图片
        UIImage *newImageNomal = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(oldImageNomal.CGImage, newImageRect)];
        UIImage *newImageSelected = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(oldImageSelected.CGImage, newImageRect)];
        
        [button setImage:newImageNomal forState:UIControlStateNormal];
        [button setImage:newImageSelected forState:UIControlStateSelected];
        
        // 将按钮添加到当前转盘视图上
        [self.luckyRotateWheelImageView addSubview:button];
        
        // 设置默认选中第一个
        if (i == 0) [self buttonClickAction:button];
        
    }
}

/**
 *  按钮点击事件监听
 */
- (void)buttonClickAction:(LuckyRotateButton *)button {
    // 1.取消之前选中的按钮状态
    self.luckyRotateButton.selected = NO;
    
    // 2.设置当前按钮为选中
    button.selected = YES;
    
    // 3.将当前按钮设置为已选中按钮
    self.luckyRotateButton = button;
}

/**
 *  开始选号按钮点击事件
 */
- (IBAction)selectNumberClickAction:(id)sender {
    self.displayLink.paused = YES;
    
    // 1.创建一个动画对象
    CABasicAnimation *basicAnimation = [CABasicAnimation animation];

    // 2.设置动画属性的键
    basicAnimation.keyPath = @"transform.rotation";
    // 3.设置动画属性的值
    basicAnimation.toValue = @angle2Radion(360 * 2);
    // 4.设置动画的时长
    basicAnimation.duration = 0.5;
    basicAnimation.delegate = self;

    // 6.将动画添加到转盘控件的layer层上
    [self.luckyRotateWheelImageView.layer addAnimation:basicAnimation forKey:nil];
    
    // 实现选中那个星座就让该星座指向转盘的中心点上
    // 根据选中按钮获取旋转角度，通过transform获取角度
    CGFloat angle = atan2(self.luckyRotateButton.transform.b, self.luckyRotateButton.transform.a);
    
    // 旋转转盘让选中按钮指向转盘的中心点上
    self.luckyRotateWheelImageView.transform = CGAffineTransformMakeRotation(-angle);
}

/**
 *  动画完成后的代理方法实现
 */
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.displayLink.paused = NO;
    });
}

/**
 *  开始旋转转盘
 */
- (void)startTurntable {
    self.displayLink.paused = NO;
}

/**
 *  停止旋转转盘
 */
- (void)pauseTurntable {
    self.displayLink.paused = YES;
}

/**
 *  懒加载定时器
 */
- (CADisplayLink *)displayLink {
    if (nil == _displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAngleChanged:)];
        
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    
    return _displayLink;
}

/**
 *  定时器执行事件处理
 */
- (void)displayLinkAngleChanged:(CADisplayLink *)displayLink {
    // 每一次调用旋转的度数45 / 60.0
    CGFloat angle = angle2Radion(45 / 60.0);
    
    // 设置转盘控件的旋转属性
    self.luckyRotateWheelImageView.transform = CGAffineTransformRotate(self.luckyRotateWheelImageView.transform, angle);
}


@end
