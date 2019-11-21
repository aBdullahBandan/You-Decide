//
//  File.swift
//  You Decide
//
//  Created by Abdullah Bandan on 02/03/1441 AH.
//  Copyright © 1441 AbdullahBandan. All rights reserved.
//

import Foundation

    // MARK: - Photo
    struct PhotoLocal: Codable {
        let id, secret, server: String
        let farm: Int
        var url: String {
            return "http://farm"+String(farm)+".staticflickr.com/"+server+"/"+id+"_"+secret+"_q.jpg"
        }
    }
