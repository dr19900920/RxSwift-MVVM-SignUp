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
    let validatedPhoneNumber: Observable<SignUpValidationResult>
    let validatedPhoneCode: Observable<SignUpValidationResult>
    let signupButtonEnabled: Observable<Bool>
    let getCodeButtonEnabled: Observable<Bool>
    
    // input flow
    init(inputPhone: Observable<String>,inputPhoneCode: Observable<String>, dependency: (
        API:SignUpAPI,
        validationService: SignUpValidationService
        )) {
            
            let validateService = dependency.validationService

            //  对输入的手机号内容和正则做判断
            validatedPhoneNumber = inputPhone
                .flatMapLatest({ phone in
                    return validateService.validatePhone(phone)
                        .observeOn(MainScheduler.instance)
                        .catchErrorJustReturn(SignUpValidationResult.Failed(message: "phone input format error"))
                    
                })
                .shareReplay(1)

            validatedPhoneCode = inputPhoneCode
                .flatMapLatest({code  in
                    return validateService.validateCode(code)
                        .observeOn(MainScheduler.instance)
                        .catchErrorJustReturn(SignUpValidationResult.Failed(message: "code input error"))
                })
                .shareReplay(1)
            //  先检查验证码
            getCodeButtonEnabled = validatedPhoneNumber.map{ phone in
                phone.isValide
                }
                .shareReplay(1)
            
            signupButtonEnabled = validatedPhoneCode.map{ code in
                code.isValide
                }
                .shareReplay(1)
    }
    
}
