//
//  HKNewsBannerView.h
//  HKNewsBannerView
//
//  Created by Mac on 16/7/8.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, HKNewsBannerViewScrollDirection) {
    HKNewsBannerViewScrollDirectionLandscape,//水平滚动
    HKNewsBannerViewScrollDirectionPortait //垂直滚动
};

@class HKNewsBannerView;
@protocol HKNewsBannerViewDelegate <NSObject>

@optional

/** 点击消息回调 */
- (void)newsBannerView:(HKNewsBannerView *)newsBannerView didSelectItemAtIndex:(NSInteger)index;
@end

@interface HKNewsBannerView : UIView
/** 消息对应的image数组*/
@property (nonatomic, strong, nullable) NSArray<NSString *> *imageArray;
/** 消息数组*/
@property (nonatomic, strong) NSArray<NSString *> *newsArray;
/** 滚动的时间*/
@property (nonatomic, assign) NSTimeInterval rollingDelayTime;
/** 滚动的方向*/
@property (nonatomic, assign) HKNewsBannerViewScrollDirection scrollDirection;
/** 消息显示颜色*/
@property (null_resettable, nonatomic, strong) UIColor *newsColor;
/** 消息字体大小*/
@property (null_resettable, nonatomic, strong) UIFont *newsFont;
/** 消息背景颜色*/
@property (nullable, nonatomic, strong) UIColor *newsBackgroundColor;
/** 代理*/
@property (nonatomic, weak) id<HKNewsBannerViewDelegate> delegate;
/** block方式监听点击 */
@property (nonatomic, copy) void (^clickNewsOperationBlock)(NSInteger tapIndex);
/**
 *  开始滚动
 */
- (void)startRolling;

/**
 *  刷新消息
 *
 *  @param newsArray 新的消息数组
 */
- (void)reloadBannerWithData:(NSArray<NSString *> *)newsArray;

/**
 *  刷新消息和图片
 *
 *  @param newsArray  新的消息
 *  @param imageArray 新的图片数组
 */
- (void)reloadBannerWithNews:(NSArray<NSString *> *)newsArray images:(NSArray<NSString *> * __nullable)imageArray;

/**
 *  推荐构造方法
 *
 *  @param frame     frame大小
 *  @param newsArray news数组
 *
 *  @return 实例
 */
+ (instancetype)newsBannerViewWithFrame:(CGRect)frame newsArray:(NSArray<NSString *> *)newsArray;

/**
 *  block构造方法
 *
 *  @param frame      frame大小
 *  @param newsArray  news数组
 *  @param clickBlock 点击消息的block tapIndex为点击的的number
 *
 *  @return 实例
 */
+ (instancetype)newsBannerViewWithFrame:(CGRect)frame newsArray:(NSArray<NSString *> *)newsArray clickNewsOperationBlock:(void(^)(NSInteger tapIndex))clickBlock;

/**
 *  block构造方法
 *
 *  @param frame      frame大小
 *  @param newsArray  news数组
 *  @param delegate 代理对象
 *
 *  @return 实例
 */
+ (instancetype)newsBannerViewWithFrame:(CGRect)frame newsArray:(NSArray<NSString *> *)newsArray delegate:(id<HKNewsBannerViewDelegate>)delegate;
@end
NS_ASSUME_NONNULL_END
