//
//  LKAntMach.h
//  LKAnt
//
//  Created by Fan Li Lin on 2021/12/30.
//  Copyright © 2021 Fan Li Lin. All rights reserved.
//

#ifndef LKAntMach_h
#define LKAntMach_h

/// 数据类型
typedef NS_ENUM(NSInteger, LKAntMachValueType) {
    /// 字符串
    LKAntMachValueTypeString = 0,
    /// 函数
    LKAntMachValueTypeFunction
};

/// 执行队列
typedef NS_ENUM(NSInteger, LKAntMachQueueType) {
    /// 主线程
    LKAntMachQueueMain = 0,
    /// 子线程异步
    LKAntMachQueueAsync = 1,
    /// 系统任务空闲的时候
    LKAntMachQueueWhenIdle = 2
};

/// 数据结构体
typedef struct LKAntMachHeader {
    LKAntMachValueType valueType;
    LKAntMachQueueType queueType;
    void *value;
}LKAntMachHeader;

typedef void (*LKAntMach_func) (void);

#endif /* LKAntMach_h */
