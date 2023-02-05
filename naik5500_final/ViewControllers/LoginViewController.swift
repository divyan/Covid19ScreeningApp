//
//  LoginViewController.swift
//  naik5500_final
//
//  Created by Divya Naiken on 2021-04-08.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {

    //MARK: UI Elements
    
    //TextFields
   
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    //Buttons
    @IBOutlet weak var login: UIButton!
   
    //Labels
    @IBOutlet weak var error: UILabel!
    
    //Variables
    var auth = false
    
    
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAllIcons()
        

        // Do any additional setup after loading the view.
    }
    
    //MARK: Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "goToDashboard")
        {
            let barViewControllers = segue.destination as! UITabBarController
            let destinationNv = barViewControllers.viewControllers?[0] as! UINavigationController
            let destinationController = destinationNv.viewControllers[0] as! DashboardViewController
                destinationController.myVariable = 0}
    }
    
    //MARK: Should Perform Segue
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (identifier == "goToDashboard")
        {
            //If the authentication worked
            if(auth == true)
            {
                return true
            }

        }
        
        return false
    }
    
    //MARK: Event Handlers
    @IBAction func loginTapped(_ sender: Any)
    {
        //Ensure that all the fields are filled in
        let theErrorMessage = errorValidation()
        
        if theErrorMessage != ""
        {
            self.displayError(theErrorMessage)
        }
        
        else
        {
            //Sign the user in
            let cEmail = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let cPassword = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Sign the user in, and see is valid
            Auth.auth().signIn(withEmail: cEmail, password: cPassword) { (result, error) in
                
                if error != nil {
                    // Couldn't sign in
                    self.error.text = error!.localizedDescription
                    self.error.alpha = 1
                }
                else {
                    //*****************************************************************************************
                    
                    //Added stuff to check if db is working:
                    let db = Firestore.firestore()
                    
                    let docRef = db.collection("users").whereField("uid", isEqualTo: Auth.auth().currentUser?.uid ?? "")


//                    docRef.getDocument { (document, error) in
//                        if let document = document, document.exists {
//                            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                            print("Document data: \(dataDescription)")
//                        } else {
//                            print("Document does not exist")
//                        }
//                    }
                    
                    //Get sspecific document from current user
                    
                            
                            // Get data
                    docRef.getDocuments { (querySnapshot, err) in
                        if let err = err {
                            print(err.localizedDescription)
                                    return
                        } else if querySnapshot!.documents.count != 1 {
                                print("More than one document or none")
                        } else {
                                let document = querySnapshot!.documents.first
                                let dataDescription = document?.data()
                                guard let firstname = dataDescription?["numEntries"] else { return }
                                print(firstname)
                            }
                        }

                    //*****************************************************************************************
                    
                    self.auth = true
                    //Navigate to dashboard
                    self.performSegue(withIdentifier: "goToDashboard", sender: self)
                    //self.navigateHome()
                }
            }
        }//else
    }//login Tapped
    
    
    @IBAction func signUpTapped(_ sender: Any) {
        performSegue(withIdentifier: "signUpIdentifier", sender: sender)
    }
    
    
    //MARK: Helper Functions
    func setAllIcons()
    {
        error.alpha = 0
        email.setIcon(_image: UIImage(named: "email_icon")!)
        password.setIcon(_image: UIImage(named: "password_icon")!)
        
        password.isSecureTextEntry = true
        
    }
    
    //Check all fields and validate data
    func errorValidation() -> String
    {
        //Check 1: All fields are filled
        if(email.text?.trimmingCharacters(in: .whitespacesAndNewlines)) == "" || password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in each field"
        }
        
        return ""
    }
    
    func displayError(_ message:String)
    {
        error.text = message
        error.alpha = 1
    }
    
    func navigateLoginView()
    {
        let vc = self.storyboard?.instantiateViewController(identifier: "SignUpView") as? SignUpViewController
        
        self.view.window?.rootViewController = vc
        self.view.window?.makeKeyAndVisible()
    }

    

}

