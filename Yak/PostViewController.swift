//
//  PostViewController.swift
//  Yak
//
//  Created by Michael Stromer on 1/15/15.
//  Copyright (c) 2015 Michael Stromer. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UITextViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var textView: UITextView!
    
    var currLocation: CLLocationCoordinate2D?
    var reset:Bool = false
    let locationManager = CLLocationManager()
    
    private func  alert() {
        let alert = UIAlertController(title: "Cannot fetch your location", message: "Please enable location in the settings menu", preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        let settings = UIAlertAction(title: "Settings", style: UIAlertActionStyle.Default) { (action) -> Void in
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
            return
        }
        alert.addAction(settings)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.selectedRange = NSMakeRange(0, 0);
        self.textView.delegate = self
        self.textView.becomeFirstResponder()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        locationManager.stopUpdatingLocation()
        if(locations.count > 0){
            let location = locations[0] as CLLocation
            currLocation = location.coordinate
        } else {
            alert()
        }
    }
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println(error)
    }
    @IBAction func cancelPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true , completion: nil)
    }

    @IBAction func postPressed(sender: AnyObject) {
        
        if(currLocation != nil){
            let testObject = PFObject(className: "Strand")
            testObject["text"] = self.textView.text
            testObject["voteLabel"] = 0
            testObject["replyLabel"] = 0
            testObject["location"] = PFGeoPoint(latitude: currLocation!.latitude , longitude: currLocation!.longitude)
            testObject.saveInBackground()
            self.dismissViewControllerAnimated(true , completion: nil)
        } else {
            alert()
        }
        
        
        
    }
    func textViewDidChange(textView: UITextView) {
        if(reset == false){
            self.textView.text = String(Array(self.textView.text)[0])
            reset = true
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
