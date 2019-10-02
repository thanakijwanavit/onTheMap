

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
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
                            self.setLoggingIn(false)
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
                    if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet
                     {
                         // No internet
                        self.showLoginFailure(message: "not connected to internet")
                        self.setLoggingIn(false)
                        return
                     }
                     else
                     {
                        self.showLoginFailure(message: "wrong password or user id")
                        self.setLoggingIn(false)
                        return
                         // Other errors
                     }
                    
                }
            }
        }

    }
    
    @IBAction func loginViaWebsiteTapped() {
        setLoggingIn(true)
        
        
        let newLink: String = "https://auth.udacity.com/sign-up"
        if UIApplication.shared.canOpenURL(URL(string: newLink)!) {
        UIApplication.shared.open(URL(string: newLink)!)
        } else {
            let alertController = UIAlertController(title: "Sorry", message: "Google Chrome app is not installed", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
        
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
