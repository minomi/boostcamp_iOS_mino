//
//  ViewController.swift
//  ImageBoard
//
//  Created by 오민호 on 2017. 7. 30..
//  Copyright © 2017년 BoostCamp. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwField: UITextField!
    
    var signUpSuccess : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if signUpSuccess {
            let alert = UIAlertController(title: "회원가입 완료!", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: false, completion: nil)
        }
        signUpSuccess = false
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        guard shouldInputAllItems() else {
            let alert = UIAlertController(title: "모든 항목을 입력해주세요", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            return
        }
        
        guard let email = emailField.text else { return  }
        guard let pw = pwField.text else { return }
        
        UserService.shared.login(email: email, password: pw) { loginResult in
            DispatchQueue.main.async {
                switch loginResult  {
                case .success(_) :
                    self.dismiss(animated: true, completion: nil)
                case let .failure(code, message) :
                    let alert = UIAlertController(title: "알림", message: "\(code)\n" + message, preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: false, completion: nil)
                }
            }
        }
    }

    
    func shouldInputAllItems() -> Bool {
        guard let email = emailField.text else { return false }
        guard let pw = pwField.text else { return false }
        return !email.isEmpty && !pw.isEmpty
    }
}

