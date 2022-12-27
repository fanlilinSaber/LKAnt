//
//  LKAntPlug.h
//  LKAnt
//
//  Created by Fan Li Lin on 2021/12/30.
//  Copyright © 2021 Fan Li Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LKAnt/LKAntMach.h>

@class LKAntContext;

@protocol LKAntPlug <NSObject>
@optional

/// 初始化完成
/// @param context context
- (void)antPlugDidLoad:(LKAntContext *)context;

/// 初始化完成
/// @param context 初始化完成
/// @param launchOptions 启动参数
- (void)antPlugDidLoad:(LKAntContext *)context launchOptions:(NSDictionary *)launchOptions;

/// 执行队列
+ (LKAntMachQueueType)queueType;

@end
