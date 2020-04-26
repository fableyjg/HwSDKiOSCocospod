//
//  SigmobRewardedVideoCustomEvent.m
//  MoPubSDK
//
//  Copyright (c) 2015 MoPub. All rights reserved.
//

#if __has_include("MoPub.h")
    #import "MPLogging.h"
    #import "MPError.h"
    #import "MPRewardedVideoReward.h"
    #import "MPRewardedVideoError.h"
    #import "MoPub.h"
#endif

#import "SigmobRewardedVideoCustomEvent.h"
#import <WindSDK/WindSDK.h>

@interface SigmobRewardedVideoCustomEvent () <WindRewardedVideoAdDelegate>

@property (nonatomic, copy) NSString *placementId;
@end

@implementation SigmobRewardedVideoCustomEvent

- (void)initializeSdkWithParameters:(NSDictionary *)parameters
{

}

- (void)requestRewardedVideoWithCustomEventInfo:(NSDictionary *)info
{
    if(![info objectForKey:@"appId"]){
        NSLog(@"sigmob reward video invalid app id");
        NSError *error =
        [NSError errorWithDomain:MoPubRewardedVideoAdsSDKDomain
                            code:MPRewardedVideoAdErrorInvalidAdUnitID
                        userInfo:@{NSLocalizedDescriptionKey : @"appId Unit ID cannot be nil."}];
        MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error],nil);
        
        [self.delegate rewardedVideoDidFailToLoadAdForCustomEvent:self error:error];
        return;
    }
    
    NSString * appId = info[@"appId"];
    NSString * apiKey = info[@"apiKey"];
    self.placementId = info[@"placementId"];
    
    WindAdOptions *options = [WindAdOptions options];
    options.appId = appId;
    options.apiKey = apiKey;
    [WindAds startWithOptions:options];
    
    [[WindRewardedVideoAd sharedInstance] setDelegate:self];
    
    [self loadSigmobAD];
}

- (void) loadSigmobAD{
    WindAdRequest *request = [WindAdRequest request];
    [[WindRewardedVideoAd sharedInstance] loadRequest:request withPlacementId:self.placementId];
}

- (BOOL)hasAdAvailable
{
    BOOL isReady = [[WindRewardedVideoAd sharedInstance] isReady:self.placementId];
    return isReady;
}

- (void)presentRewardedVideoFromViewController:(UIViewController *)viewController
{
    MPLogAdEvent([MPLogEvent adShowAttemptForAdapter:NSStringFromClass(self.class)], self.placementId);
    if([self hasAdAvailable]){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSError *error = nil;
        [defaults setObject:@"SigmobRewardedVideo" forKey:@"hwvideotype"];
        [self.delegate rewardedVideoWillAppearForCustomEvent:self];
        [[WindRewardedVideoAd sharedInstance]playAd:viewController withPlacementId:self.placementId options:nil error:&error];
        [self.delegate rewardedVideoDidAppearForCustomEvent:self];
    }else{
        NSError *error = [NSError errorWithCode:MPRewardedVideoAdErrorNoAdsAvailable localizedDescription:@"Failed to show Sigmob rewarded video: Sigmob now claims that there is no available video ad."];
        MPLogAdEvent([MPLogEvent adShowFailedForAdapter:NSStringFromClass(self.class) error:error], self.placementId);
        [self.delegate rewardedVideoDidFailToPlayForCustomEvent:self error:error];
    }
}

- (void)handleCustomEventInvalidated
{
    NSLog(@"handleCustomEventInvalidated");
}

- (void)handleAdPlayedForCustomEventNetwork
{
    //empty implementation
}

- (void)viewDidLoad {

}

#pragma mark - sigmob Delegate
/**
 激励视频广告AdServer返回广告
 @param placementId 广告位Id
 */
- (void)onVideoAdServerDidSuccess:(NSString *)placementId{
    NSLog(@"sigmob onVideoAdServerDidSuccess");
    MPLogAdEvent([MPLogEvent adLoadSuccessForAdapter:NSStringFromClass(self.class)], self.placementId);
}
/**
 激励视频广告AdServer无广告返回
 表示无广告填充
 @param placementId 广告位Id
 */
- (void)onVideoAdServerDidFail:(NSString *)placementId{
    NSLog(@"sigmob onVideoAdServerDidFail");
    [self.delegate rewardedVideoDidFailToLoadAdForCustomEvent:self error:nil];
}
/**
 激励视频广告物料加载成功(此时isReady=YES)
 广告是否加载完成请以改回调为准
 @param placementId 广告位Id
 */
-(void)onVideoAdLoadSuccess:(NSString * _Nullable)placementId{
    NSLog(@"sigmob onVideoAdLoadSuccess");
    [self.delegate rewardedVideoDidLoadAdForCustomEvent:self];
}
/**
 激励视频广告开始播放
 @param placementId 广告位Id
 */
-(void)onVideoAdPlayStart:(NSString * _Nullable)placementId{
    NSLog(@"sigmob onVideoAdPlayStart");
    //[self.delegate rewardedVideoDidAppearForCustomEvent:self];
}
/**
 激励视频广告视频播放完毕
 @param placementId 广告位Id
 */
- (void)onVideoAdPlayEnd:(NSString *)placementId{
    NSLog(@"sigmob onVideoAdPlayEnd");
    MPRewardedVideoReward *reward = [[MPRewardedVideoReward alloc] initWithCurrencyType:kMPRewardedVideoRewardCurrencyTypeUnspecified amount:@(kMPRewardedVideoRewardCurrencyAmountUnspecified)];
    
    [self.delegate rewardedVideoShouldRewardUserForCustomEvent:self reward:reward];
}
/**
 激励视频广告发生点击
 @param placementId 广告位Id
 */
-(void)onVideoAdClicked:(NSString * _Nullable)placementId{
    NSLog(@"sigmob onVideoAdClicked");
    [self.delegate rewardedVideoDidReceiveTapEventForCustomEvent:self];
}
/**
 激励视频广告关闭
 @param info WindRewardInfo里面包含一次广告关闭中的是否完整观看等参数
 @param placementId 广告位Id
 */
- (void)onVideoAdClosedWithInfo:(WindRewardInfo * _Nullable)info placementId:(NSString * _Nullable)placementId{
    [self.delegate rewardedVideoDidDisappearForCustomEvent:self];
}
/**
 激励视频广告发生错误
 @param error 发生错误时会有相应的code和message
 @param placementId 广告位Id
 */
-(void)onVideoError:(NSError *)error placementId:(NSString * _Nullable)placementId{
    NSLog(@"sigmob onVideoError");
    [self.delegate rewardedVideoDidFailToPlayForCustomEvent:self error:error];
}
/**
 激励视频广告调用播放时发生错误
 @param error 发生错误时会有相应的code和message
 @param placementId 广告位Id
 */
-(void)onVideoAdPlayError:(NSError *)error placementId:(NSString * _Nullable)placementId{
    NSLog(@"sigmob onVideoAdPlayError");
    [self.delegate rewardedVideoDidFailToPlayForCustomEvent:self error:error];
}

@end
