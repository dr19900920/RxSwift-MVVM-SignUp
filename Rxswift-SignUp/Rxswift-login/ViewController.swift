//
//  ViewController.swift
//  Rxswift-login
//
//  Created by dengrui on 16/5/13.
//  Copyright © 2016年 dengrui. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    /// 密码输入框
    @IBOutlet weak var phoneTextField: UITextField!
    /// 验证码输入框
    @IBOutlet weak var codeTextField: UITextField!
    /// 获取验证码按钮
    @IBOutlet weak var getCodeBtn: UIButton!
    /// 注册按钮
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func registerAPI() {

        let signupViewmodel = SignUpViewModel(inputPhone: phoneTextField.rx_text.asObservable(),inputPhoneCode:codeTextField.rx_text.asObservable(), dependency: (API: signUpRequest(), validationService: signUpValidationService.shareService))
        /// 把手机号是否合格跟是否能够发送验证码绑定
        signupViewmodel.validPhone
            .bindTo(getCodeBtn.rx_enabled)
            .addDisposableTo(disposeBag)
        /// 把注册和验证码手机号格式是否正确绑定
        signupViewmodel.signUpButtonEnabled
            .bindTo(signUpBtn.rx_enabled)
            .addDisposableTo(disposeBag)
        weak var tmpSelf = self
        /**
        *  监听手机输入窗的改变
        */
        phoneTextField.rx_controlEvent(.EditingChanged).subscribeNext {
            if tmpSelf!.phoneTextField.text?.characters.count >= 11 {
                tmpSelf!.phoneTextField.text = (tmpSelf!.phoneTextField.text! as NSString).substringToIndex(11)
                if tmpSelf!.phoneTextField.text! =~ kRegEx_phone {
                    tmpSelf!.phoneTextField.resignFirstResponder()
                    tmpSelf!.codeTextField.becomeFirstResponder()
                }
            }
            }.addDisposableTo(disposeBag)
        /**
        *  code文本输入监听
        */
        codeTextField.rx_controlEvent(.EditingChanged).subscribeNext {
            if tmpSelf!.codeTextField.text?.characters.count >= 4 {
                tmpSelf!.codeTextField.text = (tmpSelf!.codeTextField.text! as NSString).substringToIndex(4)
                tmpSelf!.resignFirstResponder()
            }
            }.addDisposableTo(disposeBag)
        /**
        *  发送验证码的点击事件
        */
        getCodeBtn.rx_tap.subscribeNext { () -> Void in
          
        }.addDisposableTo(disposeBag)
        /**
        *  注册的点击事件
        */
        signUpBtn.rx_tap.subscribeNext { () -> Void in
            
        }.addDisposableTo(disposeBag)
        
    }
    
    
}

