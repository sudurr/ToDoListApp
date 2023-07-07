//
//  AppDelegate.swift
//  ToDoListApp
//
//  Created by Судур Сугунушев on 15.06.2023.
//

import UIKit
import CocoaLumberjackSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: RootCoordinator?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        DDLog.add(DDOSLogger.sharedInstance)
        let window = UIWindow()
        self.window = window
        coordinator = RootCoordinatorImpl()
        coordinator?.start(in: window)

        return true
    }

}

