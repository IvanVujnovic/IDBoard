//
//  MessagesTableViewController.swift
//  IDBoard
//
//  Created by Ivan Vujnovic on 2016-05-17.
//  Copyright © 2016 Ivan Vujnovic. All rights reserved.
//

import UIKit

class MessagesTableViewController: UITableViewController {
    
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
    
    
    var messages:[Message] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        print("Messages \(#function)")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160.0
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
    }
    
        
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        print("Messages didAppear \(#function)")
        appDelegate.messagesViewController = self
        reloadMyData()
    }
    
    func reloadMyData() {
        print("Messages reloadData \(#function)")
        
        messages.removeAll()
        
        // Send a GET HTTP request with the messages
        let message = appDelegate.url_root + "messages.php"
        print(message)
        let url = NSURL(string: message)!
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                if error != nil {
                    let err = error!
                    self.showAlert("Connection error", message: err.localizedDescription, actionTitle: "OK")
                    return
                }
                
                if let urlContent = data {
                    do {
                        let jsonResult = try NSJSONSerialization.JSONObjectWithData(urlContent, options: NSJSONReadingOptions.MutableContainers)
                        //print(jsonResult)
                        let nr_obj = jsonResult.count
                        //print("nr obj = \(nr_obj)")
                        
                        for i in 0 ..< nr_obj {
                            //guard let title = jsonResult[i]["Title"] as? String, let message = jsonResult[i]["Message"] as? String
                            guard let message = jsonResult[i]["Message"] as? String
                                else {
                                print("Error = \(jsonResult)")
                                return
                            }
                            
                            let mess = Message()
                            mess.title = ""
                            mess.message = message
                            
                            self.messages.append(mess)
                        }
                        
                        if nr_obj >= 1 {
                            self.tableView.reloadData()
                        }
                    } catch {
                        print("JSON serialization failure")
                    }
                }
//                print(response)
            }
        }
        task.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("messageCell", forIndexPath: indexPath)

        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        cell.textLabel?.text = messages[indexPath.row].message
        return cell
    }
        
    func showAlert(mainTitle:String, message:String, actionTitle:String) {
        let thisAlert = UIAlertController(title: mainTitle, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        thisAlert.addAction(UIAlertAction(title: actionTitle, style: .Default, handler: { (action: UIAlertAction!) in
        }))
        
        presentViewController(thisAlert, animated: true, completion: nil)
    }
    

}
