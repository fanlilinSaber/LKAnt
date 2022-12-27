//
//  LKExampleSwiftPlug.swift
//  LKAnt IOS Example
//
//  Created by Fan Li Lin on 2022/12/27.
//  Copyright © 2022 ZHONG JUN KE JI. All rights reserved.
//

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
