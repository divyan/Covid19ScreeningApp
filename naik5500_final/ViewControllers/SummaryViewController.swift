//
//  SummaryViewController.swift
//  naik5500_final
//
//  Created by Divya Naiken on 2021-04-15.
//

import UIKit

class SummaryViewController: UIViewController {
    
    //MARK:UI Elements

    //Labels
    @IBOutlet weak var symptomsLabel: UILabel!
    @IBOutlet weak var travellingLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var isolatingLabel: UILabel!
    @IBOutlet weak var exposureLabel: UILabel!
    
    //Buttons
    @IBOutlet weak var confirmButton: UIButton!
    

    //Variable
    var resultsArray : [Int] = []
    var result: String = "unknown"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(resultsArray[0])
        
        displayResults()
        
        determineResult()
    }
    
    //MARK: Helper Functions
    func displayResults()
    {
        //Get the results array and iterate through it
        if resultsArray[0] == 0 { symptomsLabel.text = "Symptoms: No" } else if resultsArray[0] == 1 {symptomsLabel.text = "Symptoms: Yes"}
        if resultsArray[1] == 0 { travellingLabel.text = "Travelling: No" } else if resultsArray[1] == 1 {travellingLabel.text = "Travelling: Yes"}
        if resultsArray[2] == 0 { contactLabel.text = "Contact: No" } else if resultsArray[2] == 1 {contactLabel.text = "Contact: Yes"}
        if resultsArray[3] == 0 { isolatingLabel.text = "Isolating: No" } else if resultsArray[3] == 1 {isolatingLabel.text = "Isolating: Yes"}
        if resultsArray[4] == 0 { exposureLabel.text = "Exposure: No" } else if resultsArray[4] == 1 {exposureLabel.text = "Exposure: Yes"}
    }
    
    //Note: FALSE -> Not Clear, TRUE -> Clear
    func determineResult()
    {
        for element in resultsArray
        {
            if (element == 1)
            {
                result = "Not Clear"
                return
            }
        }
        
        result = "Clear"
    }
    
    

    //MARK: Event Handlers
    
    
    @IBAction func restartTapped(_ sender: Any)
    {
       
    }
    
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "displayResult")
        {
            //Send Whether clear or not to the results view controller
            let destinationController = segue.destination as! ResultsViewController
            destinationController.theResult = result 
            
        }
        
    }
    
   

}
