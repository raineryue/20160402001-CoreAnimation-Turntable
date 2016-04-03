//
//  LuckyRotateButton.m
//  20160402001-CoreAnimation-Turntable
//
//  Created by Rainer on 16/4/3.
//  Copyright © 2016年 Rainer. All rights reserved.
//

#import "LuckyRotateButton.h"

@implementation LuckyRotateButton

/**
 *  使用这个方法来返回最合适处理事件的view
 *  这里用来处理当点击了星座按钮区域下面部分出现的bug
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGFloat buttonW = self.bounds.size.width;
    CGFloat buttonH = self.bounds.size.height;
    
    CGFloat w = buttonW;
    CGFloat h = buttonH * 0.5;
    CGFloat x = 0;
    CGFloat y = h;
    
    CGRect rect = CGRectMake(x, y, w, h);
    
    if (CGRectContainsPoint(rect, point))
        return nil;
    else
        return [super hitTest:point withEvent:event];
}

/**
 *  设置图片在按钮中的位置
 */
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat imageW = 40;
    CGFloat imageH = 46;
    CGFloat imageX = (contentRect.size.width - imageW) * 0.5;
    CGFloat imageY = 20;
    
    CGRect rect = CGRectMake(imageX, imageY, imageW, imageH);
    
    return rect;
}

/**
 *  重写此方法屏蔽点击高亮状态
 */
- (void)setHighlighted:(BOOL)highlighted {

}

@end
