//
//  RHAppDelegate.swift
//  TableSwapableCell
//
//  Created by Robert Herdzik on 8/25/15.
//  Copyright (c) 2015 Ro. All rights reserved.
//

import UIKit

@UIApplicationMain
class RHAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        // Window
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        window?.makeKeyAndVisible()
        
        // Root ViewController
        let rootViewController = getPrepareRootViewController()
        let navigationController = UINavigationController(rootViewController: rootViewController)
        window?.rootViewController = navigationController
        
        return true
    }
    
    /**
     Method prepare all data related with rootViewController (MVP pattern supported):
     - mocked model with array of RHPerson objects
     - presenter for view
     - view itself
     
     - returns: prepared view controller
     */
    private func getPrepareRootViewController() -> UIViewController {
        let rawPersonsData = ["Robert Herdzik", "Tim Cook", "Natan Ash"] // Some mock example data
        let personsList: [RHPersonProtocol] = rawPersonsData.map {
            let personData = $0.characters.split{ $0 == " " }.map(String.init)
            
            return RHPerson(name: personData.first ?? "", surname: personData.last ?? "", profession: "IT")
        }
        
        let exampleListViewController = RHExampleListViewController()
        exampleListViewController.title = "RH Swipeable Cell Example"
      
        let exampleViewPresenter = RHExampleListPresenter(view: exampleListViewController, model: personsList)
        exampleListViewController.presenter = exampleViewPresenter
        
        return exampleListViewController
    }
}