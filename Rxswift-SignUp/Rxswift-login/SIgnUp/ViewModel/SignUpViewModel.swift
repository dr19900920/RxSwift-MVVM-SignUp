//
//  SignUpViewModel.swift
//  Rxswift-login
//
//  Created by dengrui on 16/5/13.
//  Copyright © 2016年 dengrui. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxAlamofire

class SignUpViewModel {
    // output flow
    let validPhone: Observable<Bool>
    let signUpButtonEnabled: Observable<Bool>
    
    // input flow
    init(inputPhone: Observable<String>,inputPhoneCode: Observable<String>, dependency: (
        API:SignUpAPI,
        validationService: SignUpValidationService
        )) {
            
            let validateService = dependency.validationService

            //  对输入的手机号内容和正则做判断
            validPhone = inputPhone
                .flatMapLatest({ phone in
                    return validateService.validatePhone(phone)
                        .observeOn(MainScheduler.instance)
                        .catchErrorJustReturn(false)
                    
                })
                .shareReplay(1)

            let validCode = inputPhoneCode
                .flatMapLatest({code  in
                    return validateService.validateCode(code)
                        .observeOn(MainScheduler.instance)
                        .catchErrorJustReturn(false)
                })
                .shareReplay(1)
            //  先检查验证码
            signUpButtonEnabled = Observable.combineLatest(validPhone, validCode) {$0 && $1}
                .shareReplay(1)
    }
    
}
