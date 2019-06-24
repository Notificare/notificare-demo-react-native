/**
 * Copyright (c) 2015-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "AppDelegate.h"
#import "NotificareReactNativeIOS.h"
#import <React/RCTBridge.h>
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  
  [NotificareReactNativeIOS launch:launchOptions];
  
  RCTBridge *bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:launchOptions];
  RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:bridge
                                                   moduleName:@"AwesomeProject"
                                            initialProperties:nil];

  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];

  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  return YES;
}

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
#else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [NotificareReactNativeIOS handleOpenURL:url withOptions:nil];
    return YES;
}

- (void)notificarePushLib:(NotificarePushLib *)library didReceiveLaunchURL:(NSURL *)launchURL {
    [NotificareReactNativeIOS handleOpenURL:launchURL withOptions:nil];
}


-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    [NotificareReactNativeIOS handleOpenURL:url withOptions:options];
    return YES;
}

#pragma APNS Delegates
//Required to handle device registrations
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken {
	[NotificareReactNativeIOS didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {

	[NotificareReactNativeIOS didReceiveRemoteNotification:userInfo completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
		if (!error) {
			completionHandler(UIBackgroundFetchResultNewData);
		} else {
			completionHandler(UIBackgroundFetchResultNoData);
		}
	}];

}

/*
 * iOS 9 and below requires this delegate to handle lock screen actions
 */
-(void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forRemoteNotification:(nonnull NSDictionary *)userInfo withResponseInfo:(nonnull NSDictionary *)responseInfo completionHandler:(nonnull void (^)())completionHandler{
	[[NotificarePushLib shared] handleActionWithIdentifier:identifier forRemoteNotification:userInfo withResponseInfo:responseInfo completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
		completionHandler();
	}];
}

@end
