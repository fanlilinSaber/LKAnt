//
//  main.m
//  LKAnt IOS Example
//
//  Created by Fan Li Lin on 2021/12/30.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        NSLog(@"main start");
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
        NSLog(@"main end");
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
