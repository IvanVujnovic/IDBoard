//
//  LogInViewController.swift
//  IDBoard
//
//  Created by Ivan Vujnovic on 2016-03-17.
//  Copyright © 2016 Ivan Vujnovic. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController, UITextFieldDelegate {

//    let url_root = "http://192.168.0.102/idboard_app/"
    let url_root = "http://youdome.com/idboard/"

    @IBOutlet weak var top: NSLayoutConstraint!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var saveCredentialsSwitch: UISwitch!


    var initTopConstraint:CGFloat = 0
    var adjustTopConstraint = false

    var saved_id: String!
    var saved_password: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
        appDelegate.firstViewController = self

        idTextField.delegate = self
        passwordTextField.delegate = self

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardUp:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardDown:"), name:UIKeyboardWillHideNotification, object: nil);
    }

    func checkIfUserCredentialsWereSaved() {
        // Check if the user's credentials are saved
        saved_id = NSUserDefaults.standardUserDefaults().stringForKey("id")
        saved_password = NSUserDefaults.standardUserDefaults().stringForKey("password")

        if saved_id != nil && saved_password != nil {
            if saved_id.isEmpty == false && saved_password.isEmpty == false {
                // This will recheck the password with the server
                idTextField.text = saved_id
                passwordTextField.text = saved_password
            }
        }
    }

    override func viewWillAppear(animated: Bool) {
        checkIfUserCredentialsWereSaved()
    }

    override func viewDidAppear(animated: Bool) {
        if(self.view.frame.height <= 480) {
            adjustTopConstraint = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func keyboardUp(notification: NSNotification) {
        var info = notification.userInfo!
        let kbFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()

        if adjustTopConstraint {
            initTopConstraint = top.constant
            top.constant = -kbFrame.size.height/5
        }
    }

    func keyboardDown(notification: NSNotification) {
        if adjustTopConstraint {
            top.constant = initTopConstraint
            initTopConstraint = 0
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == idTextField {
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
        }
        return true
    }

    override func viewDidDisappear(animated: Bool) {
        saveUserCredentials()
//        if saveCredentialsSwitch.on {
//            //print("Save credentials")
//            NSUserDefaults.standardUserDefaults().setObject(idTextField.text, forKey: "id")
//            NSUserDefaults.standardUserDefaults().setObject(passwordTextField.text, forKey: "password")
//        }
//        else {
//            print("Lose credentials")
//            idTextField.text = ""
//            passwordTextField.text = ""
//            NSUserDefaults.standardUserDefaults().setObject("", forKey: "id")
//            NSUserDefaults.standardUserDefaults().setObject("", forKey: "password")
//        }
    }

    func saveUserCredentials() {
        if saveCredentialsSwitch.on {
            //print("Save credentials")
            NSUserDefaults.standardUserDefaults().setObject(idTextField.text, forKey: "id")
            NSUserDefaults.standardUserDefaults().setObject(passwordTextField.text, forKey: "password")
        }
        else {
            print("Lose credentials")
            idTextField.text = ""
            passwordTextField.text = ""
            NSUserDefaults.standardUserDefaults().setObject("", forKey: "id")
            NSUserDefaults.standardUserDefaults().setObject("", forKey: "password")
        }
    }



    @IBAction func connectionButton(sender: AnyObject) {
        let id = idTextField.text!
        let password = passwordTextField.text!
        
        if id.isEmpty || password.isEmpty {
            showAlert("Error!", message: "User ID and password fields should be filled", actionTitle: "OK")
        }

        // Send a POST HTTP request with the user registration details
        let message = url_root + "idboard.php" + "?id=\(id)&password=\(password)"
//        print(message)
        let url = NSURL(string: message)!

        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"

        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                if error != nil {
                    let err = error!
                    self.showAlert("Connection error", message: err.localizedDescription, actionTitle: "OK")
                    return
                }

                if let urlContent = data {
                    do {
                        let jsonResult = try NSJSONSerialization.JSONObjectWithData(urlContent, options: NSJSONReadingOptions.MutableContainers)
//                        print(jsonResult)
                        if let res = jsonResult["result"] {
                            if res as! String == "YES" {
                                //print("Successful authentification")
                                NSUserDefaults.standardUserDefaults().setObject(self.idTextField.text, forKey: "id")
                                NSUserDefaults.standardUserDefaults().setObject(self.passwordTextField.text, forKey: "password")

                                self.performSegueWithIdentifier("GoToApp", sender: nil)
                            }
                            if res as! String == "NO" {
                                print("Can't authenticate")
                                self.showAlert("Error", message: "Identification failed. Please try again.", actionTitle: "OK")
                            }
                        }
                    } catch {
                        print("JSON serialization failure")
                    }
                }
//                print(response)
            }
        }
        task.resume()
    }


    func showAlert(mainTitle:String, message:String, actionTitle:String) {
        let thisAlert = UIAlertController(title: mainTitle, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        thisAlert.addAction(UIAlertAction(title: actionTitle, style: .Default, handler: { (action: UIAlertAction!) in
        }))

        presentViewController(thisAlert, animated: true, completion: nil)
    }

    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
