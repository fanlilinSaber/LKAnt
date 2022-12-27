//
//  LKExampleLoggerPlug.m
//  LKAnt IOS Example
//
//  Created by Fan Li Lin on 2021/12/30.
//  Copyright © 2021 Fan Li Lin. All rights reserved.
//

#import "LKExampleLoggerPlug.h"
#import <LKAnt/LKAnt.h>

@implementation LKExampleLoggerPlug

+ (LKAntMachQueueType)queueType
{
    return LKAntMachQueueAsync;
}

- (void)antPlugDidLoad:(LKAntContext *)context
{
    NSLog(@"日志工具配置");
}

@end
