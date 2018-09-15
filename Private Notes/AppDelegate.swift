//
//  AppDelegate.swift
//  Private Notes
//
//  Created by Martin Nava Pe&a on 24/04/18.
//  Copyright © 2018 mnava. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //let tabBarController = window?.rootViewController as! UITabBarController
        let splitViewController = window?.rootViewController as! UISplitViewController
        
        let foldersNavigationController = splitViewController.viewControllers.first as! UINavigationController
        let noteNavigationController = splitViewController.viewControllers.last as! UINavigationController
        
        noteNavigationController.topViewController!.navigationItem.rightBarButtonItem = splitViewController.displayModeButtonItem
        
        splitViewController.delegate = self
        
        //Set Manage Object Cobtext
        let controller = foldersNavigationController.topViewController as! FoldersTableViewController
        controller.managedObjectContext = self.persistentContainer.viewContext

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        return true
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, separateSecondaryFrom primaryViewController: UIViewController) -> UIViewController? {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let detailViewController = mainStoryBoard.instantiateViewController(withIdentifier: "DetailNavigationController") as! UINavigationController
        detailViewController.topViewController?.navigationItem.rightBarButtonItem = splitViewController.displayModeButtonItem
    
        return detailViewController
    }
    
    func primaryViewController(forExpanding splitViewController: UISplitViewController) -> UIViewController? {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let masterViewController = mainStoryBoard.instantiateViewController(withIdentifier: "MasterNavigationController") as! UINavigationController
        
        //Set Manage Object Cobtext
        let controller = masterViewController.topViewController as! FoldersTableViewController
        controller.managedObjectContext = self.persistentContainer.viewContext
        
        return masterViewController
    }

    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        
        let container = NSPersistentContainer(name: "privateNotes")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let nserror = error as NSError? {
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

