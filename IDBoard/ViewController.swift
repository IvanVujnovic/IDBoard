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


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
        appDelegate.lastViewController = self

        planningButton.image = UIImage(named: "hamburger")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)

        retardBarButton.image = UIImage(named: "hamburger")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)

        historiqueBarButton.image = UIImage(named: "hamburger")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)

        hideAll()
        planning.hidden = false

    }

    override func viewDidAppear(animated: Bool) {
        planning.frame = self.view.frame
        historique.frame = self.view.frame
        retard.frame = self.view.frame

        //planningButton.title = ""
//        planningButton.image = UIImage(named: "hamburger")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
//
//        retardBarButton.image = UIImage(named: "hamburger")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
//
//        historiqueBarButton.image = UIImage(named: "hamburger")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)


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

//    override func viewWillUnload() {
//        hideAll()
//        planning.hidden = false
//    }

//    override func viewDidDisappear(animated: Bool) {
//        print("background")
//    }

    /*
    override func shouldAutorotate() -> Bool {
        if (UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeLeft ||
            UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeRight ||
            UIDevice.currentDevice().orientation == UIDeviceOrientation.PortraitUpsideDown ||
            UIDevice.currentDevice().orientation == UIDeviceOrientation.Unknown) {
                //return false
                return true
        }
        else {
            //return true
            return false
        }
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.Portrait]
    }
    */

    @IBAction func planningButton(sender: AnyObject) {
        hideAll()
        planning.hidden = false
    }

    @IBAction func historiqueButton(sender: AnyObject) {
        hideAll()
        historique.hidden = false
    }

    @IBAction func retardButton(sender: AnyObject) {
        hideAll()
        retard.hidden = false
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





    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
