//
//  LKExampleRegistPlatformsPlug.m
//  LKAnt IOS Example
//
//  Created by Fan Li Lin on 2021/12/30.
//  Copyright © 2021 Fan Li Lin. All rights reserved.
//

#import "LKExampleRegistPlatformsPlug.h"
#import <LKAnt/LKAnt.h>

@implementation LKExampleRegistPlatformsPlug

+ (LKAntMachQueueType)queueType
{
    return LKAntMachQueueWhenIdle;
}

- (void)antPlugDidLoad:(LKAntContext *)context
{
    NSLog(@"开始第三方SDK注册");
//    for (int i = 0; i < 1000; i ++) {
//        NSObject *obj = NSObject.new;
//    }
    NSLog(@"完成第三方SDK注册");
}

@end
