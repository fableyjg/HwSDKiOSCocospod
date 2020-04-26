//
//  HwAds.h
//  TestMopub
//
//  Created by game team on 2020/04/23.
//  Copyright © 2019 yjg. All rights reserved.
//  current version V4.2
//
#import <Foundation/Foundation.h>
#import "MPAdConversiontracker.h"
#import "MPInterstitialAdController.h"
#import "MPRewardedVideo.h"
#import "MPAdView.h"
#import <AppsFlyerLib/AppsFlyerTracker.h>

//mopub test id
#define BANNERID @"0ac59b0996d947309c33f59d6676399f"
#define INTERID @"4f117153f5c24fa6a3a92b818a5eb630"
#define REWARDID @"8f000bd5e00246de9c789eed39ff6096"

#define ADLOADINTERVAL 10
#define MAX_FAILCOUNT 3

#define HW_INSTALLTIME @"HW_InstalllTime"
#define HW_LASTSHOWADTIME @"HW_LastShowAdTime"
#define HW_COUNTRYCODE @"HW_CountryCode"

#define HW_REWARDID @"HW_REWARDID"
#define HW_INTERID @"HW_INTERID"
#define HW_BANNERID @"HW_BANNERID"

#ifndef HwAds_h
#define HwAds_h

#endif /* HwAds_h */

@protocol HwAdsDelegate <NSObject>
@optional
//加载成功  添加delegate
- (void)hwAdsRewardedVideoLoadSuccess;
//加载失败
- (void)hwAdsRewardedVideoLoadFail;
//播放失败，不给奖励
- (void)hwAdsRewardedVideoPlayFail;
//广告展示
- (void)hwAdsRewardedVideoDidAppear;
//广告关闭
- (void)hwAdsRewardedVideoClose;
//广告被点击
- (void)hwAdsRewardedVideoClick;
//广告播放完成，给奖励，最好在这里做标记，在close中给
- (void)hwAdsRewardedVideoGiveReward;
//广告即将展示，建议在收到这个回调时，暂停游戏；
- (void)hwAdsRewardedVideoWillAppear;
@end

@protocol HWAdsInterDelegate <NSObject>
@optional
//插屏加载
- (void)hwAdsInterstitialLoadSuccess;
//加载失败
- (void)hwAdsInterstitialLoadFail;
//插屏点击 add 3.0
- (void)hwAdsInterstitialClick;
//插屏播放 add 3.0
- (void)hwAdsInterstitialShow;
//插屏关闭 add 3.0
- (void)hwAdsInterstitialClose;
@end

@protocol HWAdsBannerDelegate <NSObject>
@optional
//banner加载 add 3.1
- (void)hwAdsBannerLoadSuccess;
@end

@interface HwAds : NSObject<MPAdViewDelegate,MPInterstitialAdControllerDelegate,MPRewardedVideoDelegate,AppsFlyerTrackerDelegate>
{
//    Appcontroller *appController;
//    UIView *view;
//    RootViewController *localViewController;
}

@property (nonatomic, retain) MPInterstitialAdController *moPubinterstitial;
@property (nonatomic) MPAdView *adView;

@property (nonatomic, weak) id<HwAdsDelegate> hwAdsDelegate;
@property (nonatomic, weak) id<HWAdsInterDelegate> hwAdsInterDelegate;
@property (nonatomic, weak) id<HWAdsBannerDelegate> hwAdsBannerDelegate;
//add
//@property (nonatomic, strong) id delegate;


+ (id)instance;

- (void)initSDK:(int)serverProjectId
    hwAppToken:(NSString *) hwAppToken
    hwImportantToken:(NSString *) hwImportantToken
    hwUACToken:(NSString *) hwUACToken
    hwMonetizationToken:(NSString *) hwMonetizationToken;

- (void)showBanner;

- (void)hideBanner;

//判断banner是否加载
- (BOOL)isBannerLoad;

- (void)loadInter;

- (void)showInter;

- (BOOL)isInterLoad;

- (void)loadReward;

- (void)showReward:(NSString *)tag;

- (BOOL)isRewardLoad;

//哈乐沃德针对推广需要打的点，调用这个方法；
//对于内购打点，请用：HwPurchase，US，金额； 金额是转换成美金的价格
- (void)hwAnalyticsEvent:(NSString *)category
           action:(NSString *)action
           label:(NSString *)label;
@end


