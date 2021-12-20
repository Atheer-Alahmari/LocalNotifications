//
//  ViewController.swift
//  LocalNotifications
//
//  Created by Atheer Alahmari on 15/05/1443 AH.
//

import UIKit

class ViewController: UIViewController , UIPickerViewDataSource , UIPickerViewDelegate{
  
// ---------------------IBOutlet---------------------------
    @IBOutlet weak var totelTime_L: UILabel!
    @IBOutlet weak var h_m_L: UILabel!
    @IBOutlet weak var timer_L: UILabel! // 5 minute Timer set --  5 minute Timer Cancelled
    @IBOutlet weak var workUntil_L: UILabel!
    @IBOutlet weak var start_Timer_B: UIButton!
    @IBOutlet weak var timer_Picker: UIPickerView!
    
    
    var timerLisr = ["5 Minutes","10 Minutes","20 Minutes","30 Minutes"]
    var getTime_no = 0 // to add it on current time
    var get_NewTime = "0" // with format HH:mm am
    
    var historyList = "" //Add timer_L
    var click_hietory = 0 // to check and return to main
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
    }

    
// MARK: ---------------------------------------- funcs pickerView ----------------------------------------

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timerLisr.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return timerLisr[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let getTime = timerLisr[row].components(separatedBy: " ").first!
        getTime_no = Int(getTime)!
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
   
               return NSAttributedString(string: timerLisr[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
       }
   
    
    
// MARK: -------------------------------- All Action Button ---------------------------------------------
    
    //---------------------startTimer_Action
    @IBAction func startTimer_Action(_ sender: UIButton) {
        
        get_NewTime = get_NewTime_fun() // get format to add in workUntil_L
        
        self.workUntil_L.isHidden = false
        self.h_m_L.isHidden = false
        self.timer_L.isHidden = false
        
        
        if getTime_no != 0 {
            
            let alertVC = UIAlertController.init(title: "\(getTime_no) min Countdown ", message: "After \(getTime_no) minutes , you'll be notified. \n Turn your ringer on ", preferredStyle: .alert)

                alertVC.addAction(UIAlertAction.init(title: "ok", style: .default, handler: {UIActionHandler in
                    self.showLocalNotfication()

                self.totelTime_L.text = "Totel Time : \(self.getTime_no)"
                self.h_m_L.text = "0 hours , \(self.getTime_no) min"
                self.timer_L.text = " \(self.getTime_no) minutes Timer Set"
                self.historyList += "\n \( self.timer_L.text!) "
                self.workUntil_L.text = "Work Until : \(self.get_NewTime)"
            }))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    //---------------------cancel_Action
    @IBAction func cancel_Action(_ sender: UIButton) {
        
        if getTime_no != 0 {

            start_Timer_B.isHidden = false
            workUntil_L.isHidden = false
                
            let alertVC = UIAlertController.init(title: "Cancel Current Timer ?", message: "", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction.init(title: "Back", style: .default, handler: nil))
            alertVC.addAction(UIAlertAction.init(title: "Cancel", style: .destructive, handler: {UIActionHandler in

                self.totelTime_L.text = "Totel Time : 0 "
                self.h_m_L.text = "0 hours , 0 min"
                self.timer_L.text = " \(self.getTime_no) minute Timer Cancelled"
                self.historyList += "\n \( self.timer_L.text!) "
                self.workUntil_L.isHidden = true
                
                self.getTime_no = 0 // to update
                self.showLocalNotfication() // to cancel the timer

            }))
            self.present(alertVC, animated: true, completion: nil)
            
        }
       
    }
    
    //---------------------history_Action
    @IBAction func history_Action(_ sender: UIButton) {
        get_NewTime = get_NewTime_fun() // get format to add in workUntil_L

        if click_hietory == 0 {
            timer_L.text = historyList
            
            workUntil_L.isHidden = true
            start_Timer_B.isHidden = true
            timer_Picker.isHidden = true
            
            click_hietory += 1
        } else { //  return to main

            click_hietory = 0
            workUntil_L.isHidden = false
            start_Timer_B.isHidden = false
            timer_Picker.isHidden = false

            self.totelTime_L.text = "Totel Time : \(getTime_no) "
            self.h_m_L.text = "0 hours , \(getTime_no) min"
            self.timer_L.text = " \(getTime_no) minute Timer "
            self.workUntil_L.text = "Work Until : \(get_NewTime)"

        }
       
    }
    
    //---------------------addNewDay_Action
    @IBAction func addNewDay_Action(_ sender: UIButton) {
        let alertVC = UIAlertController.init(title: "Are you sure it's a new Day? ", message: "", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: "Cancel", style: .default, handler: nil))
        alertVC.addAction(UIAlertAction.init(title: "New Day", style: .destructive, handler: {UIActionHandler in
          
            self.historyList = ""
            self.totelTime_L.text = "Totel Time : 0 "
            self.h_m_L.isHidden = true
            self.timer_L.isHidden = true
            self.workUntil_L.isHidden = true
        
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    
 
    
    
    //----------------------- get Time format -------

    func get_NewTime_fun() -> String {
        let currentDateTime = Date().addingTimeInterval(TimeInterval(getTime_no * 60))
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let NewTime = formatter.string(from: currentDateTime ) // 10:48 PM
     return NewTime
    }
    
    
    
    
// MARK: ---------------------------------------- LocalNotfication ----------------------------------------
    
    func showLocalNotfication() {

           let content = UNMutableNotificationContent()

           content.title = NSString.localizedUserNotificationString(forKey: "Wake up!", arguments: nil)
           content.body = NSString.localizedUserNotificationString(forKey: "Rise and shine! It's morning time!", arguments: nil)
           content.sound = UNNotificationSound.default
 
        let currentDate = Date(timeIntervalSinceNow: TimeInterval(getTime_no * 60)) // Date() or from Picker
           
           let dateComponent = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: currentDate)
           
           let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
            
           // Create the request object.
           let request = UNNotificationRequest(identifier: "MorningAlarm", content: content, trigger: trigger)
            
           // Schedule the request.
           let center = UNUserNotificationCenter.current()
           center.delegate = self
           
           center.add(request) { (error : Error?) in
               if let theError = error {
                   print(theError.localizedDescription)
               }
           }
       }


   }

   extension ViewController: UNUserNotificationCenterDelegate {
       func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
           // notification arrived
           showAlert()
           print("will present notification")
           completionHandler(UNNotificationPresentationOptions.sound)
       }
       
       func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
           // notification clicked or opened
           print("did receive notification")
       }
       
       func showAlert() {
           let alertVC = UIAlertController.init(title: "Alarm", message: "Local notification received", preferredStyle: .alert)
           alertVC.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
           self.present(alertVC, animated: true, completion: nil)
       }
       
   }


 
