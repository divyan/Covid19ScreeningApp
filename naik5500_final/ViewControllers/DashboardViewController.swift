//
//  DashboardViewController.swift
//  naik5500_final
//
//  Created by Divya Naiken on 2021-04-08.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class DashboardViewController: UIViewController {
    //MARK: UI Elements
    
    //Labels
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var numOfEntriesLabel: UILabel!
    @IBOutlet weak var lastEntryLabel: UILabel!
    
    
    var myVariable = 0
    var numEntries = ""
    
    //Reference to our user's document in the cloud
    let docRef = Firestore.firestore().collection("users").whereField("uid", isEqualTo: Auth.auth().currentUser?.uid ?? "")


    @IBOutlet weak var lab: UILabel!
    
    override func viewDidLoad() {
        
        setUpNumEntries()

//        print("The number of entries for this user is:", numOfEntriesLabel.text!)
//        if(numOfEntriesLabel.text! == "0"){
//            print("I am in the first if statement /n")
//            lastEntryLabel.text = "N/A"
//            statusLabel.text = "N/A"
//        }
//        else{
            //print("I am in the else statement /n")
            self.findDateDifference()
            self.setUpStatus()
        //}
        
//        super.viewDidLoad()
//
//        self.setUpStatus()
//        self.setUpNumEntries()
//
//        if(numOfEntriesLabel.text == "0"){
//            lastEntryLabel.text = "N/A"}
//        else{
//            self.findDateDifference()}
        
    }//ViewDidLoad
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setUpNumEntries()
        
//        if(numOfEntriesLabel.text == "0"){
//            lastEntryLabel.text = "N/A"
//            statusLabel.text = "N/A"
//        }
//        else{
            self.findDateDifference()
            self.setUpStatus()
        //}
    }
        
    //MARK: Helper Functions
    //Set up the label for the status
    func setUpStatus()
    {
        //Dispatch Queue
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        docRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                print(err.localizedDescription)
                         return
            } else if querySnapshot!.documents.count != 1 {
                    print("More than one document or none")
                    return
            } else {
                    let document = querySnapshot!.documents.first
                    let dataDescription = document?.data()
                guard let v = dataDescription?["currentStatus"] else { return }
                
                //CHANGING THE COLOUR OF THE LABEL
                if (v as! String == "notclear")
                {
                    self.statusLabel.text = "not clear"
                    self.statusLabel.textColor = UIColor(red: (255/255), green: (105/255), blue: (97/255), alpha: 1.0)
                }
                
                else if (v as! String == "clear")
                {
                    self.statusLabel.text = "clear"
                    self.statusLabel.textColor = UIColor(red: (153/255), green: (202/255), blue: (60/255), alpha: 1.0)
                }
                
                else{
                    self.statusLabel.text = "unknown"
                    self.statusLabel.textColor = UIColor(red: (153/255), green: (202/255), blue: (60/255), alpha: 1.0)
                }
                dispatchGroup.leave()
                
            }
            
            dispatchGroup.notify(queue: .main) {
                print("completion status")
            }
        }
    }//Set up Status
    
    //Set up the label for the status
    func setUpNumEntries()
    {
        //Dispatch Queue
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        docRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                print(err.localizedDescription)
                         return
            } else if querySnapshot!.documents.count != 1 {
                    print("More than one document or none")
                    return
            } else {
                    let document = querySnapshot!.documents.first
                    let dataDescription = document?.data()
                guard let v = dataDescription?["numEntries"] else { return }
                print("the v value is:", v)
                
                
                let myStringNumEntries = v as! String
                self.numOfEntriesLabel.text = myStringNumEntries
                print("the value in the texfield is:", myStringNumEntries)
                self.numEntries = myStringNumEntries
                
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            print("completion num entries")
        }
       
    }
    
 
    
    func findDateDifference()
    {
        //Dispatch Queue
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        docRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                print(err.localizedDescription)
                         return
            } else if querySnapshot!.documents.count != 1 {
                    print("More than one document or none")
                    return
            } else {
                    let document = querySnapshot!.documents.first
                    if let stamp = document!.get("lastScreening") {
                    //_ = document!.documentID
                        let ts = stamp as! Timestamp
                        let aDate = ts.dateValue()
                    
                        //The calender stuff
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
                        
                        //let formattedTimeZoneStr = formatter.string(from: aDate)
                        
                    
                    //Set the label
                    self.lastEntryLabel.text = aDate.calenderTimeSinceNow()
                }
                dispatchGroup.leave()
            }
            
            dispatchGroup.notify(queue: .main) {
                print("completion time since")}
        }
        
    }//findDateDifference
 
}

extension Date
{
    func calenderTimeSinceNow() -> String
    {
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: Date())
        
        let years = components.year!
        let months = components.month!
        let days = components.day!
        let hours = components.hour!
        let minutes = components.minute!
        let seconds = components.second!
        
        if years > 0 {
            return years == 1 ? "1 year" : "\(years) years"
        } else if months > 0 {
            return months == 1 ? "1 month" : "\(months) months"
        } else if days >= 7 {
            let weeks = days / 7
            return weeks == 1 ? "1 week" : "\(weeks) weeks"
        } else if days > 0 {
            return days == 1 ? "1 day" : "\(days) days"
        } else if hours > 0 {
            return hours == 1 ? "1 hour" : "\(hours) hours"
        } else if minutes > 0 {
            return minutes == 1 ? "1 minute" : "\(minutes) mins"
        } else {
            return seconds == 1 ? "1 second" : "\(seconds) secs"
        }
    }//CalenderTimeSinceNow
    
}
