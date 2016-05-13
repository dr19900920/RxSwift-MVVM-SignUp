//
//  ViewController.swift
//  Rxswift-login
//
//  Created by dengrui on 16/5/13.
//  Copyright © 2016年 dengrui. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var getCodeBtn: UIButton!
    @IBOutlet weak var btn: UIButton!
    
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
        
        signupViewmodel.validatedPhoneNumber
            .subscribeNext { [weak self] isEmpty in
                if isEmpty.isValide == false {
                    print(self?.phoneTextField.text)
                }
            }
            .addDisposableTo(disposeBag)

        signupViewmodel.getCodeButtonEnabled
            .subscribeNext{[weak self] valid in
                self?.getCodeBtn.enabled = valid
            }
            .addDisposableTo(disposeBag)
        
        signupViewmodel.signupButtonEnabled
            .subscribeNext { [weak self] valid in
                self?.btn.enabled = valid
            }
            .addDisposableTo(disposeBag)
    }


}

