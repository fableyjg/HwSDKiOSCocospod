//
//  BURewardVideoCustomEventDelegate.m
//  mopub_adaptor
//
//  Created by bytedance_yuanhuan on 2018/9/18.
//  Copyright © 2018年 Siwant. All rights reserved.
//

#import "BUDMopub_RewardVideoCustomEventDelegate.h"
#import <BUAdSDK/BUAdSDK.h>
#import "MPRewardedVideoReward.h"

@implementation BUDMopub_RewardVideoCustomEventDelegate

- (void)rewardedVideoAdDidLoad:(BURewardedVideoAd *)rewardedVideoAd {
    NSLog(@"csj rewardedVideoAdDidLoad");
    [self.adapter.delegate rewardedVideoDidLoadAdForCustomEvent:self.adapter];
}
    
- (void)rewardedVideoAdVideoDidLoad:(BURewardedVideoAd *)rewardedVideoAd {
//    BUD_Log(@"%s", __func__);
}
    
- (void)rewardedVideoAd:(BURewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error {
    [self.adapter.delegate rewardedVideoDidFailToPlayForCustomEvent:self.adapter error:error];
}
    
- (void)rewardedVideoAdDidVisible:(BURewardedVideoAd *)rewardedVideoAd {
    [self.adapter.delegate rewardedVideoWillAppearForCustomEvent:self.adapter];
    [self.adapter.delegate rewardedVideoDidAppearForCustomEvent:self.adapter];
    [self.adapter.delegate trackImpression];
}

- (void)rewardedVideoAdDidClose:(BURewardedVideoAd *)rewardedVideoAd {
    [self.adapter.delegate rewardedVideoDidDisappearForCustomEvent:self.adapter];
}
    
- (void)rewardedVideoAdDidClick:(BURewardedVideoAd *)rewardedVideoAd {
    [self.adapter.delegate rewardedVideoDidReceiveTapEventForCustomEvent:self.adapter];
    [self.adapter.delegate trackClick];
}
    
- (void)rewardedVideoAdDidPlayFinish:(BURewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error {
    NSLog(@"csj rewardedVideoAdDidPlayFinish");
//    BUD_Log(@"%s", __func__);
}
    
- (void)rewardedVideoAdServerRewardDidSucceed:(BURewardedVideoAd *)rewardedVideoAd verify:(BOOL)verify {
    NSLog(@"csj rewardedVideoAdServerRewardDidSucceed");
    
    MPRewardedVideoReward *reward = [[MPRewardedVideoReward alloc] initWithCurrencyType:kMPRewardedVideoRewardCurrencyTypeUnspecified amount:@(kMPRewardedVideoRewardCurrencyAmountUnspecified)];
    
    [self.adapter.delegate rewardedVideoShouldRewardUserForCustomEvent:self reward:reward];
}
    
- (void)rewardedVideoAdServerRewardDidFail:(BURewardedVideoAd *)rewardedVideoAd {
//    BUD_Log(@"%s", __func__);
}

@end
