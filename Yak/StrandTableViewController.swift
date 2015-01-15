//
//  StrandTableViewController.swift
//  Yak
//
//  Created by Michael Stromer on 1/15/15.
//  Copyright (c) 2015 Michael Stromer. All rights reserved.
//

import UIKit
import CoreLocation

class StrandTableViewController: PFQueryTableViewController, CLLocationManagerDelegate {
    
    let strands = [""]
   
    let locationManager = CLLocationManager()
    var currLocation : CLLocationCoordinate2D?
    
    override init!(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.parseClassName = "Strand"
        self.textKey = "text"
        self.pullToRefreshEnabled = true
        self.objectsPerPage = 200
        
    }
    private func alert(message : String) {
        let alert = UIAlertController(title: "Oops something went wrong.", message: message, preferredStyle: UIAlertControllerStyle.Alert)
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
        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableViewAutomaticDimension
        locationManager.desiredAccuracy = 1000
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        self.tableView.reloadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        alert("Cannot fetch your location")
    }
    override func queryForTable() -> PFQuery! {
        let query = PFQuery(className: "Strand")
        if let queryLoc = currLocation {
            query.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: queryLoc.latitude, longitude: queryLoc.longitude), withinMiles: 10)
            query.limit = 200;
            query.orderByDescending("voteLabel")
        } else {
            /* Decide on how the application should react if there is no location available */
            query.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: 37.411822, longitude: -121.941125), withinMiles: 10)
            query.limit = 200;
            query.orderByAscending("createdAt")
        }
        
        return query
    }
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        locationManager.stopUpdatingLocation()
        if(locations.count > 0){
            let location = locations[0] as CLLocation
            println(location.coordinate)
            currLocation = location.coordinate
        } else {
            alert("Cannot fetch your location")
        }
    }
    override func objectAtIndexPath(indexPath: NSIndexPath!) -> PFObject! {
        var obj : PFObject? = nil
        if(indexPath.row < self.objects.count){
            obj = self.objects[indexPath.row] as? PFObject
        }
        
        return obj
    }
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!, object: PFObject!) -> PFTableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as StrandTableViewCell
        cell.strandLabel.text = object.valueForKey("text") as? String
        cell.strandLabel.numberOfLines = 0
        let score = object.valueForKey("voteLabel") as Int
        cell.voteLabel.text = "\(score)"
        cell.timeLabel.text = "\((indexPath.row + 1) * 3)m ago"
        cell.replyLabel.text = "\((indexPath.row + 1) * 1) replies"
        return cell
    }
    
    @IBAction func topButton(sender: AnyObject) {
        let hitPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        let hitIndex = self.tableView.indexPathForRowAtPoint(hitPoint)
        let object = objectAtIndexPath(hitIndex)
        object.incrementKey("voteLabel")
        object.saveInBackground()
        self.tableView.reloadData()
        
        NSLog("Top Index Path \(hitIndex?.row)")
    }
    
    @IBAction func bottomButton(sender: AnyObject) {
        let hitPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        let hitIndex = self.tableView.indexPathForRowAtPoint(hitPoint)
        let object = objectAtIndexPath(hitIndex)
        object.incrementKey("voteLabel", byAmount: -1)
        object.saveInBackground()
        self.tableView.reloadData()
        NSLog("Bottom Index Path \(hitIndex?.row)")
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }

}
