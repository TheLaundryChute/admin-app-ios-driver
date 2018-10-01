//
//  LoginViewController.swift
//  TLCAdmin
//
//  Created by Stephen Bechtold on 9/27/18.
//  Copyright © 2018 The Laundry Chute. All rights reserved.
//

import InMotionUI

open class LoginViewController : BaseLoginViewController {
    
    @IBOutlet weak public var errorMessage:UILabel!;
    @IBOutlet weak public var userName: UITextField!
    @IBOutlet weak public var password: UITextField!
    @IBOutlet weak public var loginButton: UIButton!
    @IBOutlet weak public var rememberMe: UISwitch!
    
    
    @IBAction func loginButtonWasPressed(_ sender:AnyObject) {
        super.doLogin(self.userName.text!, self.password.text!, self.rememberMe.isOn);
    }
    

    open override func handleSuccess() {
        self.resetPage();
        self.dismiss(animated: true, completion: nil);
    }
    
    open override func handleError(_ error: Error) {
        self.resetPage();
        self.errorMessage.isHidden = false;
        self.errorMessage.text = error.localizedDescription;
    }
    
    func resetPage() {
        self.userName.text = "";
        self.password.text = "";
        self.loginButton.isEnabled = true;
        self.isBusy = false;
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        // Doesn't matter what the seque is... reset the page.
        self.resetPage();
    }
    
}
