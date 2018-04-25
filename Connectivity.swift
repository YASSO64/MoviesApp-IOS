//
//  Connectivity.swift
//  MovieApp
//
//  Created by Sayed Abdo on 4/16/18.
//  Copyright © 2018 Sayed Abdo. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    class func isConnectedToInternet() -> Bool {
        print("from conn method: \(NetworkReachabilityManager()!.isReachable)");
        return NetworkReachabilityManager()!.isReachable;
    }
}
