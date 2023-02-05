//
//  HistoryViewController.swift
//  naik5500_final
//
//  Created by Divya Naiken on 2021-04-12.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: UI Components
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Variables
    //Reference to our user's document in the cloud
    let docRef = Firestore.firestore().collection("users").whereField("uid", isEqualTo: Auth.auth().currentUser?.uid ?? "")
    
    var statusArray: [Any] = [] //To hold the past statuses
    var dateArray: [Any] = [] //To hold the past dates
    var dateConvertedArray: [String] = [] //To hold the converted dates
    var statusConvertedArray: [String] = [] //To hold the converted statuses
    
    var viewDidAppearTrue = false
    var numOfEntries = "0"
    
    var didViewDidLoadShowUp = false
    
    //MARK: Protocol Subs
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        statusConvertedArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell
        
        //setUpTableElements()
        
        print("PRINTING THE STATUS ARRAY AND DATE CONVERTED ARRAY NOW")
        for element in statusConvertedArray {
          print(element)
        }
        for element2 in dateConvertedArray {
          print(element2)
        }
        
        
        
        cell.resultLabel.text = statusConvertedArray[indexPath.row]
        cell.dateLabel.text = dateConvertedArray[indexPath.row]
        
        //if results == 'clear' display check mark, if not display x
        print("The index Path row values is", indexPath.row)
        //print(statusArray[0])
        cell.resultImage.image = UIImage(named: statusConvertedArray[indexPath.row]) // as! String
        
        //WHAT YOU CAN ALSO DO HERE, IS MAKE THE IMAGE VIEW equal to UIImage(named: results[indexPath.row]) that contains either 'clear' or 'not clear', then name the image in assets 'clear' or not clear so it display the right image automically and you don't need an if clear etc.. statement
        
        
        cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 2
        cell.resultImage.layer.cornerRadius = cell.resultImage.frame.height / 2
        
        
        return cell
    }
    
    //Change the height of the rows
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Assign Delegate
        tableView.delegate = self
        tableView.dataSource = self

        //self.setUpTableElements()
        
        print("the count of the array is",statusConvertedArray.count, "and",dateConvertedArray.count)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("twice")

        viewDidAppearTrue = true
        
        
        self.setUpTableElements()
    }
    
    func setUpTableElements()
    {
        if (viewDidAppearTrue == true)
        {
            self.dateConvertedArray.removeAll()
            self.statusConvertedArray.removeAll()
        }
        
        DispatchQueue.main.async {
            self.getNumOfEntries()}
        
        
//        if(numOfEntries == "0")
//        {
//            self.dateConvertedArray.append("please complete your first screening")
//            self.statusConvertedArray.append("empty")
//
//            //Send to main thread
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
//        else
//        {
            docRef.getDocuments { [self] (querySnapshot, err) in
                if let err = err {
                    print(err.localizedDescription)
                             return
                } else if querySnapshot!.documents.count != 1 {
                    print("More than one document or none")
                    return
                } else {
                        let document = querySnapshot!.documents.first
                        //let dataDescription = document?.data()
                        //let v = dataDescription?["statusHistory"] else { return }
                    self.statusArray = document!["statusHistory"] as? Array ?? ["empty"]
                    
                        print("printing the statusHistory array now")
                        
                            if(statusArray[0] as! String == "empty")
                                {
                                self.dateConvertedArray.append("please complete your first screening")
                                self.statusConvertedArray.append("empty")
                                }
                        
//                    if(statusArray)
//                    {
//                        print("in the isempty portion")
//                        self.dateConvertedArray.append("please complete your first screening")
//                        self.statusConvertedArray.append("empty")
//                        //Send to main thread DELETE THIS MAYBE ????
//                        DispatchQueue.main.async {
//                            self.tableView.reloadData()
//                        }
//                    }
//                    else{
                        self.convertToStringObjects()}
                //}
            }
            
            docRef.getDocuments { (querySnapshot, err) in
                if let err = err {
                    print(err.localizedDescription)
                             return
                } else if querySnapshot!.documents.count != 1 {
                        print("More than one document or none")
                        return
                } else {
                        let document = querySnapshot!.documents.first
                        //let dataDescription = document?.data()
                        //let v = dataDescription?["statusHistory"] else { return }
                    self.dateArray = document!["datesHistory"] as? Array ?? [""]
                    self.convertToDateObjects()
                }
            }
            
        //}
        

    }
    
    //MARK: The following 2 functions are used to removed the random string generated after the underscore for the array fields
    func convertToDateObjects()
    {
        var i = 0
        
        for element in dateArray
        {
            //Place date into new array
            self.dateConvertedArray.append(removeExtraCharacters(theEntry: element as! String))
            
            i = i + 1
        }
        
        //Send to main thread
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func convertToStringObjects()
    {
        var i = 0
        
        for _ in statusArray
        {
            //add space to not clear HERE
            self.statusConvertedArray.append(removeExtraCharacters(theEntry: statusArray[i] as! String))
            
            print("status array at i", statusArray[i])
            print("status converted array at i", statusConvertedArray[i])
            i = i + 1
        }
        
        //Send to main thread
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func getNumOfEntries()
    {
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
                self.numOfEntries = v as! String
            }
        }
        
        //Send to main thread DELETE THIS MAYBE ????
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func removeExtraCharacters(theEntry: String) -> String
    {
        if let range = theEntry.range(of: "_") {
            let firstPart = theEntry[theEntry.startIndex..<range.lowerBound]
            return String(firstPart)
        }
        
        return " "
    }
    /*
     if let stamp = document!.get("lastScreening") {
     //_ = document!.documentID
         let ts = stamp as! Timestamp
         let aDate = ts.dateValue()
     
         //The calender stuff
         print("Calender time since now is:", aDate.calenderTimeSinceNow())
         let formatter = DateFormatter()
         formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
         let formattedTimeZoneStr = formatter.string(from: aDate)
         print("the formatted date is: ", formattedTimeZoneStr)
     
     
     */
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
