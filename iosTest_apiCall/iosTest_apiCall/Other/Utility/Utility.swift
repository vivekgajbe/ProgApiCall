//
//  Utility.swift
//  iosTest_scootsy
//
//  Created by vivek G on 15/04/20.
//  Copyright © 2020 vivek G. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration

class Utility: NSObject {
    static var shared = Utility()
    
    //MARK:- Loader
    /// Function to show loader on the screen
    func showLoader()
    {
        //Here check for the loader count and according to it show the loader. Each time increment the loader count whenever we show it on the screen
        Constants.iLoaderCount = Constants.iLoaderCount + 1
        
        if Constants.iLoaderCount == 1
        {
            Constants.APP_DEL.window?.makeToastActivity()
        }
    }
    /// Function to hide loader from the screen
    func hideLoader()
    {
        //First decrement the loader count and if it is greater than 0 then return from the function other wise set it to 0 and then hide the loader
        Constants.iLoaderCount = Constants.iLoaderCount - 1
        
        if Constants.iLoaderCount > 0
        {
            return
        }
        
        Constants.iLoaderCount = 0
        
        Constants.APP_DEL.window?.hideRMLoader()
    }
    func showAlert(strTitle:String = "",strMsg : String,onView:UIViewController)
    {
        let alert = UIAlertController(title: strTitle, message: strMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        onView.present(alert, animated: true)
    }
    public func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        if flags.isEmpty {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
}
