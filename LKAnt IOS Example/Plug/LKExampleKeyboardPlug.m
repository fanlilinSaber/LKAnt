//
//  LKExampleKeyboardPlug.m
//  LKAnt IOS Example
//
//  Created by Fan Li Lin on 2021/12/30.
//  Copyright © 2021 Fan Li Lin. All rights reserved.
//

#import "LKExampleKeyboardPlug.h"
#import <LKAnt/LKAnt.h>

LKAnt_EXPORT_METHOD_Q(setupWhenIdle, 2) {
    NSLog(@"setup WhenIdle");
}

@implementation LKExampleKeyboardPlug

- (void)antPlugDidLoad:(LKAntContext *)context
{
    NSLog(@"全局键盘设置");
}

@end
