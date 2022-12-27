//
//  LKAntMacros.h
//  LKAnt
//
//  Created by Fan Li Lin on 2021/12/30.
//  Copyright © 2021 Fan Li Lin. All rights reserved.
//

#ifndef LKAntMacros_h
#define LKAntMacros_h
#import <LKAnt/LKAntMach.h>

#define LKAntAnnotationDATA(sectionName) __attribute((used, section("__DATA,"#sectionName" ")))

/**
 *  使用这个来注入一个模块
 *  like this: LKAnt_EXPORT_MODULE(MyModule)
 */
#define LKAnt_EXPORT_MODULE(name) \
char * kAnt##name##_module LKAntAnnotationDATA(LKAnt_STRING) = "M:"#name"";

/**
 *  使用这个来注入一个方法
 *  like this: LKAnt_EXPORT_METHOD(MyMethod)
 */
#define LKAnt_EXPORT_METHOD(name) LKAnt_EXPORT_METHOD_Q(name, 0)

/**
 *  使用这个来注入一个方法
 *  like this: LKAnt_EXPORT_METHOD_Q(MyMethod, 2)
 *  remark：q = 0 在主线程；q = 1 子线程异步；q = 2 系统任务空闲的时候
 */
#define LKAnt_EXPORT_METHOD_Q(name, q) \
static void LKAnt_Func_##name(void); \
LKAntAnnotationDATA(LKAnt_FUNC) \
static const LKAntMachHeader _F_##name = (LKAntMachHeader){LKAntMachValueTypeFunction,q,LKAnt_Func_##name}; \
static void LKAnt_Func_##name(void)

#endif /* LKAntMacros_h */
