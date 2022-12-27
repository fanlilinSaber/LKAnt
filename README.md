# LKAnt
ant:如其名学习蚂蚁精神（他们分工明确，各司其职，各尽其能），为了解决项目的代码臃肿，启动性能问题等，合理分工；把启动注册项分散管理，分阶段启动。

LKAnt框架为宿主和其他子壳工程提供了基础服务的依赖和初始化配置。同时提供了一套启动加载的 BootTasks 管理框架，部分业务涉及启动相关的逻辑可以在业务仓对应的服务层中实现，并通过 BootTasks 管理框架注册到启动加载器里面。启动项维护方式可插拔，启动项之间、业务模块之间不耦合，且一次实现可在多端复用。

LKAnt的核心思想就是在编译时把数据（如函数指针）写入到可执行文件的__DATA段中，运行时再从__DATA段取出数据进行相应的操作（调用函数）。

LKAnt实现原理简述：Clang 提供了很多的编译器函数，它们可以完成不同的功能。其中一种就是 section() 函数，section()函数提供了二进制段的读写能力，它可以将一些编译期就可以确定的常量写入数据段。 在具体的实现中，主要分为编译期和运行时两个部分。在编译期，编译器会将标记了 attribute((section())) 的数据写到指定的数据段中，例如写一个{key(key代表不同的启动阶段), *pointer}对到数据段。到运行时，在合适的时间节点，在根据key读取出函数指针，完成函数的调用。

## 功能特点

- 支持OC和Swift

## 预览

## 安装

### CocoaPods 安装使用

- ①请在Podfile中指定→ pod 'LKAnt'
- ②然后终端执行 `pod install`

### Fork的私有仓库地址
pod 'LKAnt', :git => 'https://x.xx.com/xxx/LKAnt.git'

## 使用

**OC**
```Objective-C

在LKExampleNetworkConfigPlug.m文件中

#import "LKExampleNetworkConfigPlug.h"
#import <LKAnt/LKAnt.h>

@implementation LKExampleNetworkConfigPlug

- (void)antPlugDidLoad:(LKAntContext *)context
{
    NSLog(@"全局网络请求配置");
}

在AppDelegate.m文件中
/// 注入启动模块
LKAnt_EXPORT_MODULE(LKExampleNetworkConfigPlug)

@end

```

**Swift**
```Swift
在LKExampleSwiftPlug.swift文件中

import UIKit
import LKAnt

@objc(LKExampleSwiftPlug)
class LKExampleSwiftPlug: NSObject {

}

extension LKExampleSwiftPlug: LKAntPlug {
    
    func antPlugDidLoad(_ context: LKAntContext!) {
        print("swift 文件测试")
    }
}

```

## 更新日志

* 2022年4月12日 `v1.0.1`
  - 1.新增`application`和`launchOptions`系统默认属性设置

* 2021年12月30日 `v1.0.0`
  - 1.第一个版本上线；分阶段启动和启动项自注册
