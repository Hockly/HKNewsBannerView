//
//  HKNewsBannerView.m
//  HKNewsBannerView
//
//  Created by Mac on 16/7/8.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "HKNewsBannerView.h"
#import "HKNewsButton.h"

@interface HKNewsBannerView() <UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSMutableArray<HKNewsButton *> *buttonsArray;
@end

@implementation HKNewsBannerView

- (NSMutableArray<HKNewsButton *> *)buttonsArray
{
    if (!_buttonsArray) {
        _buttonsArray = [NSMutableArray<HKNewsButton *> array];
    }
    return _buttonsArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialization];
        [self setupMainView];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initialization];
    [self setupMainView];
}

- (void)initialization
{
    _rollingDelayTime = 2.0;
    _scrollDirection = HKNewsBannerViewScrollDirectionPortait;
    _newsColor = [UIColor blackColor];
    _newsFont = [UIFont systemFontOfSize:14];
}

+ (instancetype)newsBannerViewWithFrame:(CGRect)frame newsArray:(NSArray<NSString *> *)newsArray
{
    HKNewsBannerView *newBannerView = [[self alloc] initWithFrame:frame];
    newBannerView.newsArray = newsArray;
    return newBannerView;
}

+ (instancetype)newsBannerViewWithFrame:(CGRect)frame newsArray:(NSArray<NSString *> *)newsArray clickNewsOperationBlock:(void(^)(NSInteger tapIndex))clickBlock
{
    HKNewsBannerView *newBannerView = [[self alloc] initWithFrame:frame];
    newBannerView.newsArray = newsArray;
    newBannerView.clickNewsOperationBlock = [clickBlock copy];
    return newBannerView;
}

+ (instancetype)newsBannerViewWithFrame:(CGRect)frame newsArray:(NSArray<NSString *> *)newsArray delegate:(id<HKNewsBannerViewDelegate>)delegate
{
    HKNewsBannerView *newBannerView = [[self alloc] initWithFrame:frame];
    newBannerView.newsArray = newsArray;
    newBannerView.delegate = delegate;
    return newBannerView;
}

- (void)setupMainView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    if (self.scrollDirection == HKNewsBannerViewScrollDirectionLandscape) {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 3, self.scrollView.frame.size.height);
    }else{
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height * 3);
    }
    
    //新建3个button,无限滚动
    for (NSInteger i = 0; i < 3; i++) {
        HKNewsButton *newsButton = [HKNewsButton buttonWithType:UIButtonTypeCustom];
        [newsButton setTitleColor:_newsColor forState:UIControlStateNormal];
        [newsButton.titleLabel setFont:_newsFont];
        [newsButton addTarget:self action:@selector(handleTap) forControlEvents:UIControlEventTouchUpInside];
        
        //水平滚动布局
        if (self.scrollDirection == HKNewsBannerViewScrollDirectionLandscape) {
            newsButton.frame = CGRectOffset(self.bounds, self.scrollView.frame.size.width * i, 0);
        }else{
            newsButton.frame = CGRectOffset(self.bounds, 0, self.scrollView.frame.size.height * i);
        }
        
        [self.scrollView addSubview:newsButton];
        [self.buttonsArray addObject:newsButton];
    }
}

/**
 *  刷新ScrollView
 */
- (void)refreshScrollView
{
    NSArray<NSString *> *currentDisplayNews = [self getDisplayNewsWithPageIndex:self.currentPage];
    [self.buttonsArray[0] setTitle:currentDisplayNews[0] forState:UIControlStateNormal];
    [self.buttonsArray[1] setTitle:currentDisplayNews[1] forState:UIControlStateNormal];
    [self.buttonsArray[2] setTitle:currentDisplayNews[2] forState:UIControlStateNormal];
    
    NSArray<NSString *> *currentDisplayImages = [self getDisplayImagesWithPageIndex:self.currentPage];
    if (currentDisplayImages) {
        for (NSInteger i = 0; i < 3; i++) {
            if (![currentDisplayImages[i] isEqualToString:@""]) {
                [self.buttonsArray[i] setImage:[UIImage imageNamed:currentDisplayImages[i]] forState:UIControlStateNormal];
            }else{
                [self.buttonsArray[i] setImage:nil forState:UIControlStateNormal];
            }
        }
    }else{
        [self.buttonsArray[0] setImage:nil forState:UIControlStateNormal];
        [self.buttonsArray[1] setImage:nil forState:UIControlStateNormal];
        [self.buttonsArray[2] setImage:nil forState:UIControlStateNormal];
    }
    
    if (self.scrollDirection == HKNewsBannerViewScrollDirectionLandscape) {
        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    }else{
        self.scrollView.contentOffset = CGPointMake(0, self.scrollView.frame.size.height);
    }
}

/**
 *  根据当前的pageindex,获取需要展示的3个news
 *
 *  @param pageIndex 当前的pageindex
 *
 *  @return 3个news数组
 */
- (NSArray<NSString *> *)getDisplayNewsWithPageIndex:(NSInteger)pageIndex
{
    NSInteger previousIndex = [self getPageIndex:(self.currentPage - 1)];
    NSInteger nextIndex = [self getPageIndex:(self.currentPage + 1)];
    NSMutableArray<NSString *> *tempNewsArray = [[NSMutableArray<NSString *> alloc] initWithCapacity:0];
    [tempNewsArray addObject:self.newsArray[previousIndex - 1]];
    [tempNewsArray addObject:self.newsArray[self.currentPage - 1]];
    [tempNewsArray addObject:self.newsArray[nextIndex - 1]];
    return tempNewsArray;
}

- (NSArray<NSString *> *)getDisplayImagesWithPageIndex:(NSInteger)pageIndex
{
    if (!self.imageArray) return nil;
    
    NSInteger absNum = ABS(self.newsArray.count - self.imageArray.count);
    for (NSInteger i = 0; i < absNum; i++) {
        if (self.newsArray.count < self.imageArray.count) {
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.imageArray];
            [tempArray removeObjectAtIndex:(self.imageArray.count - 1)];
            self.imageArray = [tempArray copy];
        }else{
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.imageArray];
            [tempArray addObject:@""];
            self.imageArray = [tempArray copy];
        }
    }
    
    NSInteger previousIndex = [self getPageIndex:(self.currentPage - 1)];
    NSInteger nextIndex = [self getPageIndex:(self.currentPage + 1)];
    NSMutableArray<NSString *> *tempImagesArray = [[NSMutableArray<NSString *> alloc] initWithCapacity:0];
    [tempImagesArray addObject:self.imageArray[previousIndex - 1]];
    [tempImagesArray addObject:self.imageArray[self.currentPage - 1]];
    [tempImagesArray addObject:self.imageArray[nextIndex - 1]];
    return tempImagesArray;
}

/**
 *  根据当前的pageindex,获取pageindex
 *
 *  @param index pageindex
 *
 *  @return 准确的pageindex
 */
- (NSInteger)getPageIndex:(NSInteger)index
{
    NSInteger totalPage = self.newsArray.count;
    NSInteger pageIndex = index;
    if (index == 0) {
        pageIndex = totalPage;
    }
    if (index == (totalPage + 1)) {
        pageIndex = 1;
    }
    return pageIndex;
}

- (void)startRolling
{
    if (self.newsArray.count < 2 || !self.newsArray) return;
    //先取消滚动
    [self stopRolling];
    [self performSelector:@selector(rollingScrollAction) withObject:nil afterDelay:0.1];
}

- (void)reloadBannerWithData:(NSArray<NSString *> *)newsArray
{
    [self reloadBannerWithNews:newsArray images:nil];
}

- (void)reloadBannerWithNews:(NSArray<NSString *> *)newsArray images:(NSArray<NSString *> *)imageArray
{
    self.newsArray = newsArray;
    self.imageArray = imageArray;
    self.currentPage = 0;
    [self startRolling];
}

- (void)stopRolling
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rollingScrollAction) object:nil];
}

- (void)rollingScrollAction
{
    [UIView animateWithDuration:0.25 animations:^{
        if (self.scrollDirection == HKNewsBannerViewScrollDirectionLandscape) {
            self.scrollView.contentOffset = CGPointMake(1.99 * self.scrollView.frame.size.width, 0);
        }else{
            self.scrollView.contentOffset = CGPointMake(0, 1.99 * self.scrollView.frame.size.height);
        }
    } completion:^(BOOL finished) {
        if (finished) {
            self.currentPage = [self getPageIndex:(self.currentPage + 1)];
            [self refreshScrollView];
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rollingScrollAction) object:nil];
            [self performSelector:@selector(rollingScrollAction) withObject:nil afterDelay:self.rollingDelayTime inModes:@[NSRunLoopCommonModes]];
        }
    }];
}

/**
 *  消息button的点击事件
 */
- (void)handleTap
{
    if ([self.delegate respondsToSelector:@selector(newsBannerView:didSelectItemAtIndex:)]) {
        [self.delegate newsBannerView:self didSelectItemAtIndex:(self.currentPage - 1)];
    }
    
    !self.clickNewsOperationBlock ? : self.clickNewsOperationBlock(self.currentPage - 1);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat offsetY = scrollView.contentOffset.y;
    //取消已加入的延迟线程
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rollingScrollAction) object:nil];
    
    // 水平滚动
    if (self.scrollDirection == HKNewsBannerViewScrollDirectionLandscape) {
        if (offsetX >= 2 * self.scrollView.frame.size.width) {
            self.currentPage = [self getPageIndex:(self.currentPage + 1)];
            [self refreshScrollView];
        }
        
        if (offsetX <= 0) {
            self.currentPage = [self getPageIndex:(self.currentPage - 1)];
            [self refreshScrollView];
        }
    }else{
        if (offsetY >= 2 * self.scrollView.frame.size.width) {
            self.currentPage = [self getPageIndex:(self.currentPage + 1)];
            [self refreshScrollView];
        }
        
        if (offsetY <= 0) {
            self.currentPage = [self getPageIndex:(self.currentPage - 1)];
            [self refreshScrollView];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.scrollDirection == HKNewsBannerViewScrollDirectionLandscape) {
        self.scrollView.contentOffset = CGPointMake(scrollView.frame.size.width, 0);
    }else{
        self.scrollView.contentOffset = CGPointMake(0, scrollView.frame.size.height);
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rollingScrollAction) object:nil];
    [self performSelector:@selector(rollingScrollAction) withObject:nil afterDelay:self.rollingDelayTime inModes:@[NSRunLoopCommonModes]];
}

#pragma mark- set方法
- (void)setNewsColor:(UIColor *)newsColor
{
    _newsColor = newsColor;
    for (NSInteger i = 0; i < 3; i++) {
        [self.buttonsArray[i] setTitleColor:newsColor forState:UIControlStateNormal];
    }
}

- (void)setNewsFont:(UIFont *)newsFont
{
    _newsFont = newsFont;
    for (NSInteger i = 0; i < 3; i++) {
        [self.buttonsArray[i].titleLabel setFont:newsFont];
    }
}

- (void)setNewsBackgroundColor:(UIColor *)newsBackgroundColor
{
    _newsBackgroundColor = newsBackgroundColor;
    for (NSInteger i = 0; i < 3; i++) {
        [self.buttonsArray[i] setBackgroundColor:newsBackgroundColor];
    }
}
@end
