//
//  ViewController.m
//  20160402001-CoreAnimation-Turntable
//
//  Created by Rainer on 16/4/2.
//  Copyright © 2016年 Rainer. All rights reserved.
//

#import "ViewController.h"
#import "TurntableView.h"

@interface ViewController ()

@property (nonatomic, strong) TurntableView *turntableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.创建一个转盘对象
    self.turntableView = [TurntableView turntableView];
    
    // 2.设置转盘的位置
    self.turntableView.center = self.view.center;
    
    // 3.将转盘添加到控制器视图上
    [self.view addSubview:self.turntableView];
}

/**
 *  开始按钮点击事件
 */
- (IBAction)startButtonClickAction:(id)sender {
    [self.turntableView startTurntable];
}

/**
 *  停止按钮点击事件
 */
- (IBAction)pauseButtonClickAction:(id)sender {
    [self.turntableView pauseTurntable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
