# HKNewsBannerView
### 无限循环头条消息轮播(一步设置即可使用)

     // 只需一步设置
     HKNewsBannerView *newsView = [HKNewsBannerView newsBannerViewWithFrame:CGRectMake(100, 100, 200, 50) newsArray:消息数组 clickNewsOperationBlock:^(NSInteger tapIndex) {
        NSLog(@"点击了消息%zd", tapIndex);
    }];
    
 ---------------------------------------------------------------------------------------------------------------
