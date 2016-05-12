//
//  ViewController.swift
//  IDBoard
//
//  Created by Ivan Vujnovic on 2016-03-17.
//  Copyright © 2016 Ivan Vujnovic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var planning: UIView!
    @IBOutlet weak var historique: UIView!
    @IBOutlet weak var retard: UIView!

   @IBOutlet weak var planningButton: UIBarButtonItem!
   @IBOutlet weak var retardBarButton: UIBarButtonItem!
   @IBOutlet weak var historiqueBarButton: UIBarButtonItem!
    
    @IBOutlet weak var dateRangeLabel: UILabel!
    @IBOutlet weak var calendarWebView: UIWebView!
    
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
    var today = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        appDelegate.lastViewController = self

        planningButton.image = UIImage(named: "hamburger")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)

        retardBarButton.image = UIImage(named: "hamburger")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)

        historiqueBarButton.image = UIImage(named: "hamburger")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)

        hideAll()
        planning.hidden = false
        
        dateRangeLabel.text = getDateInterval(today)
        
        calendarWebView.scrollView.bounces = false
        calendarWebView.scrollView.scrollEnabled = false
        let listDates = getListDays(today)
        //print(listDates)
        calendarWebView.loadRequest(getURLRequest(listDates))
    }
    
    func getURLRequest(listDates: String) -> NSURLRequest {
        let url_str = appDelegate.url_root + "/index.php?list_dates=\(listDates)"
        print(url_str)
        let url = NSURL(string: url_str)!;
        return NSURLRequest(URL: url)
    }
    
    func getListDays(date: NSDate) -> String {
        let startDate = getStartDate(date)
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd_MM_yyyy_EEE"
        var list = "'"
        for i in 0...4 {
            let d = formatter.stringFromDate(getDateOffset(startDate!, offsetDays: i)!)
            if i < 4 {
                list = list + d + ","
            } else {
                list = list + d
            }
        }
        list = list + "'"
        return list
    }
    
    // For other date format patterns see http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
    //                                     https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/DataFormatting/Articles/dfDateFormatting10_4.html#//apple_ref/doc/uid/TP40002369-SW13
    func getDateInterval(date: NSDate) -> String {
        let startDate = getStartDate(date)
        let endDate = getDateOffset(startDate!, offsetDays: 6)
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        
        let formatterDay = NSDateFormatter()
        formatterDay.dateFormat = "dd"
        
        
        let str = formatterDay.stringFromDate(startDate!) + " - " + formatterDay.stringFromDate(endDate!) + " " + formatter.stringFromDate(endDate!)
        return str
    }
    
    // get week's Monday date
    func getStartDate(date: NSDate) -> NSDate? {
        let comp = NSCalendar.currentCalendar().components([.Day, .Month, .Year, .WeekOfMonth, .Weekday], fromDate: date)
        
        // get first day of THIS week as in Monday 
        let components = NSDateComponents()
        components.year = comp.year
        components.month = comp.month
        components.weekOfMonth = comp.weekOfMonth
        components.weekday = 2 // this is MONDAY :)
        
        let newDate = NSCalendar.currentCalendar().dateFromComponents(components)
        return newDate
    }
    
    func getDateOffset(date: NSDate, offsetDays: Int) -> NSDate? {
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        return cal?.dateByAddingUnit(NSCalendarUnit.Day, value: offsetDays, toDate: date, options: [])
    }


    override func viewDidAppear(animated: Bool) {
        planning.frame = self.view.frame
        historique.frame = self.view.frame
        retard.frame = self.view.frame

        hideAll()
        planning.hidden = false
    }

    func goBack() {
        performSegueWithIdentifier("GoToFront", sender: nil)
    }

    func refreshHamburgerViews() {
        hideAll()
        planning.hidden = false
    }


    @IBAction func planningButton(sender: AnyObject) {
        hideAll()
        planning.hidden = false
        today = NSDate()

        let listDates = getListDays(today)
        calendarWebView.loadRequest(getURLRequest(listDates))
    }
    
    @IBAction func historiqueButton(sender: AnyObject) {
        hideAll()
        historique.hidden = false
        today = NSDate()
    }

    @IBAction func retardButton(sender: AnyObject) {
        hideAll()
        retard.hidden = false
        today = NSDate()
    }


    func hideAll() {
        planning.hidden = true
        historique.hidden = true
        retard.hidden = true
        planning.frame.origin.x = 0
        historique.frame.origin.x = 0
        retard.frame.origin.x = 0
        flagPlanning = false
        flagHistorique = false
        flagRetard = false
    }

    var flagPlanning = false
    @IBAction func hambPlanning(sender: AnyObject) {
        flagPlanning = !flagPlanning

        if(flagPlanning) {
            planning.frame.origin.x = 200
        }
        else {
            planning.frame.origin.x = 0
        }
        
        print(#function)
    }

    var flagHistorique = false
    @IBAction func hambHistorique(sender: AnyObject) {
        flagHistorique = !flagHistorique

        if(flagHistorique) {
            historique.frame.origin.x = 200
        }
        else {
            historique.frame.origin.x = 0
        }
    }

    var flagRetard = false
    @IBAction func hambRetard(sender: AnyObject) {
        flagRetard = !flagRetard

        if(flagRetard) {
            retard.frame.origin.x = 200
        }
        else {
            retard.frame.origin.x = 0
        }
    }
    
    // MARK: Change week
    @IBAction func rightRangeDateTap(sender: AnyObject) {
        today = getDateOffset(today, offsetDays: 7)!
        dateRangeLabel.text = getDateInterval(today)
        let listDates = getListDays(today)
        calendarWebView.loadRequest(getURLRequest(listDates))
    }
    
    
    @IBAction func leftRangeDateTap(sender: AnyObject) {
        today = getDateOffset(today, offsetDays: -7)!
        dateRangeLabel.text = getDateInterval(today)
        let listDates = getListDays(today)
        calendarWebView.loadRequest(getURLRequest(listDates))
    }

    
    
    
    
    
    
    
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
