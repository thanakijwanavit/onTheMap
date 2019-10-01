

import UIKit

class LoginViewController: UIViewController {
    
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginViaWebsiteButton: UIButton!
    
    
    
    func requestTokenResponse(success: Bool, error: Error?) {
        
    }
    
    func handleLoginResponse(success: Bool, Error: Error?){
        
    }
    
    
    func handleSessionResponse(success: Bool, Error: Error?){
        if success{
            print("session key obtained successfully, performing segue")
            setLoggingIn(false)
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "completeLogin", sender: nil)
            }
        } else {
            print(Error as Any)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = "nicxxx@gmail.com"
        passwordTextField.text = "PZTj4EB8hP2Z"
        setLoggingIn(false)
        // only use for testing
        _ = OnTheMapClient.getDummy()
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        setLoggingIn(true)
        OnTheMapClient.login(username: emailTextField.text ?? "", password: passwordTextField.text ?? "") { (success, error) in
            if success {
                print("logged in successfully")
                DispatchQueue.main.async {
                    OnTheMapClient.getLocation(completion: { (success, error) in
                        if success {
                            print("list of users updated")
                            self.performSegue(withIdentifier: "completeLogin", sender: nil)
                            
                        } else {
                            print("error requesting users \(String(describing: error))")
                            let alert = UIAlertController(title: "Error", message: "network error", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    })
                }
                
            } else {
                print("logging in unsuccessful")
                if error != nil {
                    self.showLoginFailure(message: String(describing: error))
                    return
                }
            }
        }

    }
    
    @IBAction func loginViaWebsiteTapped() {
        setLoggingIn(true)
        
    }
    
    
    func setLoggingIn(_ loggingIn: Bool){
        if loggingIn{
            activityIndicator.startAnimating()
            //            emailTextField.state = state
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}
