//
//  ScreeningViewController.swift
//  naik5500_final
//
//  Created by Divya Naiken on 2021-04-15.
//

import UIKit


class ScreeningViewController: UIViewController, UITextViewDelegate {
    
    //MARK: UI Elements
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    let questions = Question()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TextView Delegate
        textView.delegate = self
        
        questions.resetResultsArray()
        textView.text = questions.getCurrentQuestion()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        questions.resetResultsArray()
        textView.text = questions.getCurrentQuestion()

    }
    
    //MARK: Event Handlers
    @IBAction func yesTapped(_ sender: Any)
    {
        questions.increaseAnswered()
        questions.changeResult(atThisIndex: questions.getCurrentIndex())
        questions.increaseIndex()
        
        print("the current Index is", questions.getCurrentIndex())
        print("isDone is", questions.isDone())
        //Change the question
        if(questions.isDone() == false)
        {
            textView.text = questions.getCurrentQuestion()
        }
        else
        {
            performSegue(withIdentifier: "summaryTransition", sender: self)
        }
        
    }
    
    @IBAction func noTapped(_ sender: Any)
    {
        //Note: No need to change the resutls array
        questions.increaseAnswered()
        questions.increaseIndex()
        
        //Change the question
        if(questions.isDone() == false)
        {
            textView.text = questions.getCurrentQuestion()
        }
        
    }
    
   
    
    
    // MARK: - Navigation
    //MARK: Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "summaryTransition" || segue.identifier == "summaryTransition2")
        {
            let destinationController = segue.destination as! SummaryViewController
            destinationController.resultsArray = questions.getResultsArray()
        }
    }
    
    //MARK: Should Perform Segue
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (questions.isDone() == true)
        {
            return true
        }
        
        return false
    }
    
    @IBAction func unwindToFirstViewController(_ sender: UIStoryboardSegue) {
         // No code needed, no need to connect the IBAction explicitely
        questions.resetResultsArray()
        textView.text = questions.getCurrentQuestion()
        }


}
