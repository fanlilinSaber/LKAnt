//
//  LKExampleAppearancePlug.m
//  LKAnt IOS Example
//
//  Created by Fan Li Lin on 2021/12/30.
//  Copyright © 2021 Fan Li Lin. All rights reserved.
//

#import "LKExampleAppearancePlug.h"
#import <LKAnt/LKAnt.h>

LKAnt_EXPORT_METHOD(setup) {
    NSLog(@"setup");
}

@implementation LKExampleAppearancePlug

- (void)antPlugDidLoad:(LKAntContext *)context
{
    NSLog(@"全局外观配置");
}

@end
