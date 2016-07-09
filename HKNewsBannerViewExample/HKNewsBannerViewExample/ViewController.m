//
//  ViewController.m
//  HKNewsBannerViewExample
//
//  Created by 胡凯 on 16/7/9.
//  Copyright © 2016年 hukai. All rights reserved.
//

#import "ViewController.h"
#import "HKNewsBannerView.h"

@interface ViewController ()
@property (nonatomic,weak) HKNewsBannerView *newsView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HKNewsBannerView *newsView = [[HKNewsBannerView alloc] initWithFrame:CGRectMake(100, 100, 200, 50)];
    NSArray *newsArr = @[@"张龙为啥这么帅",@"群翔snack来了",@"我爱吃十翅一桶",@"重大事故发生了"];
    newsView.newsArray = newsArr;
    newsView.imageArray = @[@"laba",@"laba",@"laba",@"laba"];
    newsView.newsColor = [UIColor redColor];
    newsView.clickNewsOperationBlock = ^(NSInteger tapIndex){
        NSLog(@"点击了消息%zd", tapIndex);
    };
    [newsView startRolling];
    [self.view addSubview:newsView];
    _newsView = newsView;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(200, 200, 40, 20)];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"点我" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)tap
{
    NSArray *newsArr = @[@"我爱美女宋慧乔",@"跑男为啥要开除光头强",@"十翅一桶真的有那么好吃",@"洪水淹没了武汉"];
    [self.newsView reloadBannerWithNews:newsArr images:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
