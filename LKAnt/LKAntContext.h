//
//  LKAntContext.h
//  LKAnt
//
//  Created by Fan Li Lin on 2021/12/30.
//  Copyright © 2021 Fan Li Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LKAntContext : NSObject
/// application
@property (nonatomic, readonly) UIApplication *application;
/// launchOptions
@property (nonatomic, readonly) NSDictionary *launchOptions;

/// sharedContext
+ (instancetype)sharedContext;

/// 启动所有注入的模块和方法
- (void)start;

/// 执行注入的模块
- (void)executeModule;

/// 执行注入的方法
- (void)executeMethod;

/// 设置application信息
/// @param application application
/// @param launchOptions launchOptions
- (void)setApplication:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions;

@end

