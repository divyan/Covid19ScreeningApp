//
//  SignUpViewController.swift
//  naik5500_final
//
//  Created by Divya Naiken on 2021-04-08.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController {

    //MARK: UI Elements
    
    //Textfields
    @IBOutlet weak var fName: UITextField!
    @IBOutlet weak var lName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    //Labels
    @IBOutlet weak var error: UILabel!
    
    //Buttons
    @IBOutlet weak var done: UIButton!

    //Variables
    var proceed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAllIcons()
        

    }
    
    //MARK: Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let barViewControllers = segue.destination as! UITabBarController
        let destinationNv = barViewControllers.viewControllers?[0] as! UINavigationController
        let destinationController = destinationNv.viewControllers[0] as! DashboardViewController
        destinationController.myVariable = 2
    }
    
    //MARK: Should Perform Segue
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (identifier == "transitionToDash")
        {
            //If the authentication worked
            if(proceed == true)
            {
                return true
            }

        }
        
        return false
    }
    
    //MARK: Event Handlers

    @IBAction func doneTapped(_ sender: Any)
    {
        //Make sure the fields contain valid data
        let error = errorValidation()
        
        //Fields are not valid 
        if error != ""
        {
            displayError(error)
        }
        
        //Create the User
        else
        {
            
            //Clean Data
            // Create cleaned versions of the data
            let cFName = fName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let cLName = lName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let cEmail = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let cPassword = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            print(cEmail)
            // Create the user
            Auth.auth().createUser(withEmail: cEmail, password: cPassword) { (result, err) in
                
                // Check for errors
                if err != nil {
                    
                    // There was an error creating the user
                    self.displayError("Error creating user")
                }//If
                else {
                    
                    // Firestore Object
                    let db = Firestore.firestore()
                    
                    //Add all the data
                    db.collection("users").addDocument(
                        data: [
                            "uid": result!.user.uid,
                            "firstname":cFName,
                            "lastname":cLName,
                            "currentStatus":"unknown",
                            //"datesHistory": ["unknown"], //Timestamp(date: Date())
                            "numEntries": "0",
                            //"statusHistory": ["unknown"]
                            
                            //PUT IN THE CURRENT DATE AS LAST ASSESSMENT DATE SO THE KEY LASTSCREENING IS CREATED 
                        ])
                    { (error) in
                        
                        if error != nil {
                            // Show error message
                            self.displayError("Error saving user data")
                        }
                    }
                    
                    self.proceed = true
                    self.performSegue(withIdentifier: "transitionToDash", sender: self)
                    // Transition to the home screen
                    //self.navigateHome()
                   
                }//Else
                
            }//Authentication
        }
        //Transition to the dashboard
    }//doneTapped
    
    
    //MARK: Helper Functions
    func setAllIcons()
    {
        error.alpha = 0
        fName.setIcon(_image: UIImage(named: "user_icon")!)
        lName.setIcon(_image: UIImage(named: "user_icon")!)
        email.setIcon(_image: UIImage(named: "email_icon")!)
        password.setIcon(_image: UIImage(named: "password_icon")!)
        
    }
    
    //Check all fields and validate data
    func errorValidation() -> String
    {
        //Check 1: All fields are filled
        if(fName.text?.trimmingCharacters(in: .whitespacesAndNewlines)) == "" || lName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in each field"}
        
        //Check 2: Password is valid
        let thePassword = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if isPasswordValid(thePassword) == false
        {
            return "Please ensure your password has 4 characters and contains at least one letter"
        }
        
        return ""
    }
    
    func isPasswordValid(_ password: String) ->Bool
    {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])[A-Za-z\\d$@$#!%*?&]{4,}")
        return passwordTest.evaluate(with: password)
    }
    
    func displayError(_ message:String)
    {
        error.text = message
        error.alpha = 1
    }
    
    func navigateHome()
    {
        let dashboardViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.dashboardViewController) as? DashboardViewController
        
        //Assign the dashbaord as the root view controller
        view.window?.rootViewController = dashboardViewController
        view.window?.makeKeyAndVisible()
    }
    

}

//MARK:Extension
// This allows pictures to be placed in the textfield
extension UITextField
{
    //Set pictures for text fields
    func setIcon(_image: UIImage)
    {
        let iconView = UIImageView(frame: CGRect(x:10, y:5, width:20,height:20))
        iconView.image = _image
        
        let iconContainerView: UIView = UIView(frame:
                          CGRect(x: 20, y: 0, width: 30, height: 30))
           iconContainerView.addSubview(iconView)
           leftView = iconContainerView
           leftViewMode = .always
        
    }
}
