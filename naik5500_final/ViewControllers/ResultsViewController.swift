//
//  ResultsViewController.swift
//  naik5500_final
//
//  Created by Divya Naiken on 2021-04-15.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import Firebase

class ResultsViewController: UIViewController {
    
    //MARK: UI Elements
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var resultsImage: UIImageView!
    
    //Variable
    var theResult: String = ""
    let docRef = Firestore.firestore().collection("users").whereField("uid", isEqualTo: Auth.auth().currentUser?.uid ?? "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("The result in the ResultsViewController is", theResult)
        
        //Display the results of the assessment
        displayResult()
        
        if(theResult == "Not Clear")
        {
            docRef.getDocuments { (querySnapshot, err) in
                if let err = err {
                    print(err.localizedDescription)
                            return
                } else if querySnapshot!.documents.count != 1 {
                        print("More than one document or none")
                } else {
                        let document = querySnapshot!.documents.first
                    document?.reference.updateData(["currentStatus": "notclear"])
                    }
                }
            
            //Add to results array
            docRef.getDocuments { (querySnapshot, err) in
                if let err = err {
                    print(err.localizedDescription)
                            return
                } else if querySnapshot!.documents.count != 1 {
                        print("More than one document or none")
                } else {
                    print("Im in this parttt")
                        let document = querySnapshot!.documents.first
                    document?.reference.updateData(["statusHistory": FirebaseFirestore.FieldValue.arrayUnion(["notclear_"+self.randomString(length: 5)])])
                    }
                }
            
                print("Im in this part")
        }
        
        else if(theResult == "Clear")
        {
            docRef.getDocuments { (querySnapshot, err) in
                if let err = err {
                    print(err.localizedDescription)
                            return
                } else if querySnapshot!.documents.count != 1 {
                        print("More than one document or none")
                } else {
                        let document = querySnapshot!.documents.first
                    document?.reference.updateData(["currentStatus": "clear"])
                    }
                }
            
            
            //Add to results array
            docRef.getDocuments { (querySnapshot, err) in
                if let err = err {
                    print(err.localizedDescription)
                            return
                } else if querySnapshot!.documents.count != 1 {
                        print("More than one document or none")
                } else {
                        let document = querySnapshot!.documents.first
                    document?.reference.updateData(["statusHistory": FieldValue.arrayUnion(["clear_"+self.randomString(length: 5)])])
                    }
                }
        }
        
        
        //Add to results array
        docRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                print(err.localizedDescription)
                        return
            } else if querySnapshot!.documents.count != 1 {
                    print("More than one document or none")
            } else {
                    let document = querySnapshot!.documents.first
                let mything = document?.documentID
                
        
        //Update the number of queries by using a TRANSACTION
                let sfReference = Firestore.firestore().collection("users").document(mything!)
        

        Firestore.firestore().runTransaction({ (transaction, errorPointer) -> Any? in
            let sfDocument: DocumentSnapshot
            do {
                try sfDocument = transaction.getDocument(sfReference)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }

            guard let oldNumber = sfDocument.data()?["numEntries"] as? String else {
                let error = NSError(
                    domain: "AppErrorDomain",
                    code: -1,
                    userInfo: [
                        NSLocalizedDescriptionKey: "Unable to retrieve population from snapshot \(sfDocument)"
                    ]
                )
                errorPointer?.pointee = error
                return nil
            }
            
            //Transform the entry
            var newNumberInt = Int(oldNumber) ?? 0
            //Add one
            newNumberInt = newNumberInt + 1
            //Turn into a String
            let newNumberString = String(newNumberInt)

            // Note: this could be done without a transaction
            //       by updating the population using FieldValue.increment()
            transaction.updateData(["numEntries": newNumberString], forDocument: sfReference)
            return nil
        }) { (object, error) in
            if let error = error {
                print("Transaction failed: \(error)")
            } else {
                print("Transaction successfully committed!")
            }
        }
            }}
        
        
        
        //Update the timestamp
        docRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                print(err.localizedDescription)
                        return
            } else if querySnapshot!.documents.count != 1 {
                    print("More than one document or none")
            } else {
                    let document = querySnapshot!.documents.first
                document?.reference.updateData(["lastScreening": FirebaseFirestore.FieldValue.serverTimestamp()])
                }
            }
        
        //Add to dates array
        docRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                print(err.localizedDescription)
                        return
            } else if querySnapshot!.documents.count != 1 {
                    print("More than one document or none")
            } else {
                    let document = querySnapshot!.documents.first

                    let date = Date()

                    //Format the date
                    let formatter = DateFormatter()
                    formatter.dateFormat = "EEEE MMM dd"
                    let formattedTimeZoneStr = formatter.string(from: date)
                //Get the current time
                //Create the time stamp to append to the history array
                //let createdAt = Firestore.firestore().
                document?.reference.updateData(["datesHistory": FieldValue.arrayUnion([formattedTimeZoneStr+"_"+self.randomString(length: 5)])])
                }
            }
        
        
        
    }
    
    func displayResult()
    {
        if(theResult == "Not Clear")
        {
            resultsLabel.text = "Not Clear"
            resultsImage.image = UIImage(named: "notclear")
        }
        
        else{
            resultsLabel.text = "Clear"
            resultsImage.image = UIImage(named: "clear")
        }
    }
    

    /*
    // MARK: - Random String Generator

    // This function is used since array entires in firestore must be unquie, in order to append unquie entires, I attached
    // a random string at the end of th entries, the HistoryViewController will take care of this extra bit and remove the extra s=character when displaying to the user
    
    */
    func randomString(length: Int) -> String {

        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)

        var randomString = ""

        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }

        return randomString
    }
}
