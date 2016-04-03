//
//  TurntableView.h
//  20160402001-CoreAnimation-Turntable
//
//  Created by Rainer on 16/4/2.
//  Copyright © 2016年 Rainer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TurntableView : UIView

/**
 *  快速创建一个转盘对象
 */
+ (instancetype)turntableView;

/**
 *  开始旋转转盘
 */
- (void)startTurntable;

/**
 *  停止旋转转盘
 */
- (void)pauseTurntable;

@end
