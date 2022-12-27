//
//  LKAntContext.m
//  LKAnt
//
//  Created by Fan Li Lin on 2021/12/30.
//  Copyright © 2021 Fan Li Lin. All rights reserved.
//

#import "LKAntContext.h"
#include <mach-o/getsect.h>
#include <mach-o/loader.h>
#include <mach-o/dyld.h>
#include <dlfcn.h>
#import "LKAntMach.h"
#import "LKAntPlug.h"

NSString *const LKAntFirstIdleInMainNotification = @"LKAntFirstIdleInMainNotification";

NSArray * LKAntReadConfigFromSection(NSString *sectionName) {
    Dl_info info;
    if (dladdr((const void *)&LKAntReadConfigFromSection, &info) == 0) {
        return nil;
    }
    
    struct mach_header_64 *machOHeader = info.dli_fbase;
    if ([sectionName hasSuffix:@"STRING"]) {
        NSMutableArray *dataArray = NSMutableArray.array;
        unsigned long size = 0;
        uint64_t *memory = (uint64_t*)getsectiondata(machOHeader, SEG_DATA, sectionName.UTF8String, &size);
        if (memory == NULL) { return nil;}
        for(int idx = 0; idx < size/sizeof(void*); ++idx){
            char *cString = (char*)memory[idx];
            NSString *string = [NSString stringWithUTF8String:cString];
            if(!string)continue;
            if(string) [dataArray addObject:string];
        }
        return dataArray;
    }else if ([sectionName hasSuffix:@"FUNC"]) {
        NSMutableArray *dataArray = NSMutableArray.array;
        uint64_t mach_header = (uint64_t)info.dli_fbase;
        const struct section_64 *section = getsectbynamefromheader_64(machOHeader, SEG_DATA, sectionName.UTF8String);
        if (section == NULL) { return nil;}
        size_t size = sizeof(LKAntMachHeader);
        for (uint64_t add = mach_header + section->offset; add < mach_header + section->offset + section->size ; add += size) {
            LKAntMachHeader headerP = *(LKAntMachHeader *)add;
            NSValue *value = [NSValue valueWithBytes:&headerP objCType:@encode(LKAntMachHeader)];
            [dataArray addObject:value];
        }
        return dataArray;
    }
    return nil;
    
    
}

@interface LKAntContext ()
@property (nonatomic, copy) NSArray *moduleIdleTasks;
@property (nonatomic, copy) NSArray *methodIdleTasks;
@property (nonatomic, copy) NSDictionary *modulePlugs;
@property (nonatomic) UIApplication *application;
@property (nonatomic) NSDictionary *launchOptions;
@end

@implementation LKAntContext

+ (instancetype)sharedContext
{
    static LKAntContext *context = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        context = [[self alloc] init];
    });
    return context;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _moduleIdleTasks = @[];
        _methodIdleTasks = @[];
        _modulePlugs = @{};
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(idleNotification:) name:LKAntFirstIdleInMainNotification object:nil];
    }
    return self;
}

- (void)start
{
    [self executeMethod];
    [self executeModule];
}

- (void)executeModule
{
    NSArray<NSString *> *dataArray = LKAntReadConfigFromSection(@"LKAnt_STRING");
    if (dataArray == nil || dataArray.count == 0) { return;}

    NSMutableDictionary *modulePlugs = self.modulePlugs.mutableCopy;
    NSMutableArray *moduleIdleTasks = self.moduleIdleTasks.mutableCopy;
    for (NSString *item in dataArray) {
        NSArray *components = [item componentsSeparatedByString:@":"];
        if (components.count >= 2) {
            NSString *type = components[0];
            if ([type isEqualToString:@"M"]) {
                NSString *className = components[1];
                Class aClass = NSClassFromString(className);
                if (!aClass) { continue; }
                NSAssert([aClass conformsToProtocol:@protocol(LKAntPlug)], @"Plug Must Conform To LKAntPlug");
                
                LKAntMachQueueType queueType = LKAntMachQueueMain;
                if ([aClass respondsToSelector:@selector(queueType)]) {
                    queueType = [aClass queueType];
                }
                
                if (queueType == LKAntMachQueueMain) {
                    id<LKAntPlug> module = [[aClass alloc] init];
                    if ([module respondsToSelector:@selector(antPlugDidLoad:)]) {
                        [module antPlugDidLoad:self];
                    }else if ([module respondsToSelector:@selector(antPlugDidLoad:launchOptions:)]) {
                        [module antPlugDidLoad:self launchOptions:self.launchOptions];
                    }
                    [modulePlugs setValue:module forKey:className];
                }else if (queueType == LKAntMachQueueAsync) {
                    id<LKAntPlug> module = [[aClass alloc] init];
                    if ([module respondsToSelector:@selector(antPlugDidLoad:)]) {
                        dispatch_async(dispatch_get_global_queue(0, 0), ^{
                            [module antPlugDidLoad:self];
                        });
                    }else if ([module respondsToSelector:@selector(antPlugDidLoad:launchOptions:)]) {
                        dispatch_async(dispatch_get_global_queue(0, 0), ^{
                            [module antPlugDidLoad:self launchOptions:self.launchOptions];
                        });
                    }
                    [modulePlugs setValue:module forKey:className];
                }else if (queueType == LKAntMachQueueWhenIdle) {
                    [moduleIdleTasks addObject:className];
                }
            }
        }
    }
    
    self.modulePlugs = modulePlugs.copy;
    self.moduleIdleTasks = moduleIdleTasks.copy;
    if (self.moduleIdleTasks.count) {
        [self postNotificationWhenIdle];
    }
}

- (void)executeMethod
{
    NSArray<NSString *> *dataArray = LKAntReadConfigFromSection(@"LKAnt_FUNC");
    if (dataArray == nil || dataArray.count == 0) { return;}
    
    NSMutableArray *methodIdleTasks = self.methodIdleTasks.mutableCopy;
    for (NSValue *value in dataArray) {
        LKAntMachHeader header;
        [value getValue:&header];
        if (header.valueType == LKAntMachValueTypeFunction && header.queueType == LKAntMachQueueMain) {
            LKAntMach_func f = header.value;
            f();
        }else if (header.valueType == LKAntMachValueTypeFunction && header.queueType == LKAntMachQueueAsync) {
            LKAntMach_func f = header.value;
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                f();
            });
        }
        else if (header.valueType == LKAntMachValueTypeFunction && header.queueType == LKAntMachQueueWhenIdle) {
            [methodIdleTasks addObject:value];
        }
    }
    
    self.methodIdleTasks = methodIdleTasks.copy;
    if (self.methodIdleTasks.count) {
        [self postNotificationWhenIdle];
    }
}

- (void)postNotificationWhenIdle
{
    NSNotification *idleNotification = [NSNotification notificationWithName:LKAntFirstIdleInMainNotification object:nil];
    [[NSNotificationQueue defaultQueue] enqueueNotification:idleNotification postingStyle:NSPostWhenIdle coalesceMask:NSNotificationCoalescingOnName forModes:@[NSDefaultRunLoopMode]];
}

- (void)idleNotification:(NSNotification *)notification
{
    NSLog(@"LKAntFirstIdleInMainNotification");
    NSArray *methodIdleTasks = self.methodIdleTasks.copy;
    NSArray *moduleIdleTasks = self.moduleIdleTasks.copy;
    NSMutableDictionary *modulePlugs = self.modulePlugs.mutableCopy;
    
    for (NSValue *value in methodIdleTasks) {
        LKAntMachHeader header;
        [value getValue:&header];
        if (header.valueType == LKAntMachValueTypeFunction && header.queueType == LKAntMachQueueWhenIdle) {
            LKAntMach_func f = header.value;
            f();
        }
    }
    
    for (NSString *className in moduleIdleTasks) {
        Class aClass = NSClassFromString(className);
        if (!aClass) { continue; }
        id<LKAntPlug> module = [[aClass alloc] init];
        if ([module respondsToSelector:@selector(antPlugDidLoad:)]) {
            [module antPlugDidLoad:self];
        }else if ([module respondsToSelector:@selector(antPlugDidLoad:launchOptions:)]) {
            [module antPlugDidLoad:self launchOptions:self.launchOptions];
        }
        [modulePlugs setValue:module forKey:className];
    }
    
    self.modulePlugs = modulePlugs.copy;
    self.moduleIdleTasks = @[];
    self.methodIdleTasks = @[];
}

- (void)setApplication:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions
{
    self.application = application;
    self.launchOptions = launchOptions;
}

@end
