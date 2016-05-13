//
//  SignUpRequest.swift
//  Rxswift-login
//
//  Created by dengrui on 16/5/13.
//  Copyright © 2016年 dengrui. All rights reserved.
//

import UIKit
import RxSwift
import RxAlamofire
import Alamofire

let kRegEx_phone = "^(0|86|17951)?(13[0-9]|15[012356789]|17[0-9]|18[0-9]|14[57])[0-9]{8}$"

struct RegexHelper {
    let regex: NSRegularExpression
    
    init(_ pattern: String) throws {
        try regex = NSRegularExpression(pattern: pattern,
            options: .CaseInsensitive)
    }
    
    func match(input: String) -> Bool {
        let matches = regex.matchesInString(input,
            options: [],
            range: NSMakeRange(0, input.characters.count))
        return matches.count > 0
    }
}

infix operator =~ {
associativity none
precedence 130
}

func =~(lhs: String, rhs: String) -> Bool {
    do {
        return try RegexHelper(rhs).match(lhs)
    } catch _ {
        return false
    }
}

var disposeBag = DisposeBag()

enum YRPError: ErrorType {
    case NoError
    case HaveError
}
private func baseURL(urlString: String) -> String {
    return "这里放主urlstring\(urlString)"
}

public func YRPRequestJSON(method: Alamofire.Method = .POST,
    URLString: String,
    parameters: AnyObject?,
    encoding: Alamofire.ParameterEncoding = .JSON,
    headers: [String: String]? = nil)
    -> Observable<AnyObject>
{
    let urlString = baseURL("这里放副urlstring")
    let paramDic: [String: AnyObject] = ["request":["params":parameters!]]
    print("--------------request--------------")
    print(paramDic)
    return JSON(method, urlString, parameters: paramDic, encoding: encoding, headers: headers)
        .map({ (json) in
            print("--------------response--------------")
            print(json)
            return json
        })

}

class signUpRequest: SignUpAPI {
    //  负责接口请求
    func phoneAvailable(phone: String) -> Observable<Bool> {
        let paramters = ["phone":phone] as [String: AnyObject]
        return YRPRequestJSON(URLString: "这里放请求手机号是否存在的urlstring", parameters: paramters)
            .map({ (json) in
                if let result = json["isExist"] {
                    let r = result as! NSString
                    return r.isEqualToString("0")
                }
                return false
            })
    }
}

class signUpValidationService: SignUpValidationService {
    let api: SignUpAPI
    
    init(api: SignUpAPI) {
        self.api = api
    }
    static let shareService = signUpValidationService(api: signUpRequest())
    
    let number = 11
    func validatePhone(phone: String) -> Observable<SignUpValidationResult> {
        if phone.characters.count < 11  {
            return Observable.just(.Empty)
        }
        else if (phone =~ kRegEx_phone) == false {
            print("请输入正确的手机号")
            return Observable.just(SignUpValidationResult.Failed(message: "phone error"))
        }
        else {
            
            print("正在检查手机号...")
        }
        return api.phoneAvailable(phone)
            .map{available in
                if available {
                    print("手机号可注册")
                    return SignUpValidationResult.OK(message: "phone ok")
                }
                else {
                    print("手机号已存在")
                    return SignUpValidationResult.Failed(message: "手机号已存在")
                }
            }
            .startWith(SignUpValidationResult.Validating)
    }
    func validateCode(code: String) -> Observable<SignUpValidationResult> {
        if code.characters.count != 4 {
            return Observable.just(.Empty)
        }
        return Observable.just(.OK(message: "ok"))
        
    }

}
