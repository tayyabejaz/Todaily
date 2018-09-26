//
//  AppDelegate.swift
//  Todaily
//
//  Created by Tayyab Ejaz on 17/09/2018.
//  Copyright © 2018 Tayyab Ejaz. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        do {
            let realm = try Realm()
        }
        catch
        {
            print("Error in Creating Realm \(error)")
        }
        return true
    }

    
   
    
}

