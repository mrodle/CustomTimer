//
//  AppCenter.swift
//  CustomTimer
//
//  Created by Eldor Makkambayev on 17.12.2023.
//

import Foundation
import UIKit

class AppCenter {
    
    //MARK: - Properties
    var window: UIWindow = UIWindow()
    static let shared = AppCenter()
    private var currentViewController: UIViewController = UIViewController()
    private var width = UIScreen.main.bounds.width
    
    
    //MARK: - Start functions
    func createWindow(_ window: UIWindow) -> Void {
        self.window = window
    }
    
    func start() -> Void {
        makeKeyAndVisible()
        makeRootController()
    }
        
    private func makeKeyAndVisible() -> Void {
        window.backgroundColor = .white
        window.makeKeyAndVisible()
    }
    
    func setRootController(_ controller: UIViewController) -> Void {
        currentViewController = controller
        window.rootViewController = currentViewController
    }
     
    func makeRootController() -> Void {
        let vc = TimerViewController()
        setRootController(vc)
    }
    
    
    //MARK: - functions
    func addSubview(view: UIView) -> Void {
        window.addSubview(view)
    }
}
