//
//  Question.swift
//  All questions based off of COVID-19 Screening Tool for Businesses and Organizations (Screening Workers)

/*For more information,see the link [COVID-19 Screening Tool for Businesses and Organizations](https://covid-19.ontario.ca/covid19-cms-assets/2021-01/Guidance-Screening-Workplace-Jan7_EN.pdf/)s
 */

//  naik5500_final
//
//  Created by Divya Naiken on 2021-04-13.
//

import Foundation
import UIKit

class Question
{
    //This will be a singleton
    static let shared = Question() 
    
    var question1: String
    var question2: String
    var question3: String
    var question4: String
    var question5: String
    
    var index: Int
    
    var questionsArray: [String] = []
    
    var results: [Int] = []
    
    var answered: Int
    
    let numOfQuestions = 5

    init()
    {
        //Initialize all the questions
        self.question1 = "Question 1:\n\nDo you have any of the following new or worsening symptoms or signs? Symptoms should not be chronic or related to other known causes or conditions.\n\nFever and/or chills Temperature of 37.8 degrees Celsius/100 degrees Fahrenheit or higher\n\nCough or barking cough (croup) Continuous, more than usual, making a whistling noise when breathing, not related to other known causes or conditions (for example, asthma, post-infectious reactive airways, COPD)\n\nShortness of breath Out of breath, unable to breathe deeply, not related to other known causes or conditions (for example, asthma)\n\nDecrease or loss of smell or taste Not related to other known causes or conditions (for example, allergies, neurological disorders)\n Sore throat Not related to other known causes or conditions (for example, seasonal allergies, acid reflux)\n\nDifficulty swallowing Painful swallowing, not related to other known causes or conditions\n\nPink eye Conjunctivitis, not related to other known causes or conditions (for example, reoccurring styes)\n\nRunny or stuffy/congested nose Not related to other known causes or conditions (for example, seasonal allergies, being outside in cold weather)\n\nHeadache that’s unusual or long lasting Not related to other known causes or conditions (for example, tension-type headaches, chronic migraines)\n\nDigestive issues like nausea/vomiting, diarrhea, stomach pain Not related to other known causes or conditions (for example, irritable bowel syndrome, menstrual cramps)\n\nMuscle aches that are unusual or long lasting Not related to other known causes or conditions (for example, a sudden injury, fibromyalgia)\n\nExtreme tiredness that is unusual Fatigue, lack of energy, not related to other known causes or conditions (for example, depression, insomnia, thyroid dysfunction)\n\nFalling down often For older people"
        
        self.question2 = "Question 2:\n\nHave you travelled outside of Canada in the last 14 days? If you are an essential worker who crosses the Canada-US border regularly for work, select 'No'."
        
        self.question3 = "Question 3:\n\nIn the last 14 days, has a public health unit identified you as a close contact of someone who currently has COVID-19?"
        
        self.question4 = "Question 4:\n\nHas a doctor, health care provider, or public health unit told you that you should currently be isolating (staying at home)?"
        
        self.question5 = "Question 5\n\nIn the last 14 days, have you received a COVID Alert exposure notification on your cell? If you already went for a test and got a negative result, select 'No'."

        //Place all the questions into the question array
        self.questionsArray.append(question1)
        self.questionsArray.append(question2)
        self.questionsArray.append(question3)
        self.questionsArray.append(question4)
        self.questionsArray.append(question5)
        
        //Initialize the index
        self.index = 0
        
        //Initialize this array to 0 for all the questions
        for _ in questionsArray
        {
            results.append(0)   //This initializes the results array to 5 zeros for 5 questions
        }
        
        //Initialize the answered variable
        self.answered = 0

    }
    
    func getResultsArray() -> [Int]
    {
        return results
    }
    
    func getCurrentQuestion() -> String
    {
        return questionsArray[index]
    }
    
    func getCurrentIndex() -> Int
    {
        return index
    }
    
    func getQuestionAt(thisIndex: Int) -> String
    {
        return questionsArray[thisIndex]
    }
    
    /*This function is called change result because the results array is initially set to all zeros e..g [0,0,0,0,0]
     We will change the result at a particular index to 1 if the user answers "yes" to any of the questions
     Note: if this function is used, that means the user will fail the assessment and receive the "not clear" status
    */
    func changeResult(atThisIndex: Int)
    {
        results[atThisIndex] = 1
    }
    
    func resetResultsArray()
    {
        var i = 0
        for _ in results
        {
            results[i] = 0
            i = i + 1
        }
        
        index = 0
        answered = 0
    }
    
    func increaseAnswered()
    {
        answered = answered + 1
    }
    
    func isDone() -> Bool
    {
        if answered == numOfQuestions
        {
            return true
        }
        
        else
        {
            return false
        }
    }
    
    func increaseIndex()
    {
        index = index + 1
    }
    
}

