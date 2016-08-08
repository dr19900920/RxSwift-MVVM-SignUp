//
//  SignUpApi.swift
//  Rxswift-login
//
//  Created by dengrui on 16/5/13.
//  Copyright © 2016年 dengrui. All rights reserved.
//

import UIKit
import RxAlamofire
import RxSwift


//  网络请求，相当于对后台的调试接口
protocol SignUpAPI {
    //  接口：验证手机号码是否可用
    func phoneAvailable(phone: String) -> Observable<Bool>

}

//  正则校验，相当于对用户输入内容的限制
protocol SignUpValidationService {
    func validatePhone(phone: String) -> Observable<Bool>
    func validateCode(code: String) -> Observable<Bool>
}
