//
//  AppDelegate.m
//  LKAnt IOS Example
//
//  Created by Fan Li Lin on 2021/12/30.
//

#import "AppDelegate.h"
#import <LKAnt/LKAnt.h>


/// 注入启动模块
LKAnt_EXPORT_MODULE(LKExampleAppearancePlug)
LKAnt_EXPORT_MODULE(LKExampleKeyboardPlug)
LKAnt_EXPORT_MODULE(LKExampleLoggerPlug)
LKAnt_EXPORT_MODULE(LKExampleNetworkConfigPlug)
LKAnt_EXPORT_MODULE(LKExampleRegistPlatformsPlug)
LKAnt_EXPORT_MODULE(LKExampleNetworkPlug)
LKAnt_EXPORT_MODULE(LKExampleSwiftPlug)


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[LKAntContext sharedContext] start];
    return YES;
}

@end
