//
//  FlickerRespones.swift
//  You Decide
//
//  Created by Abdullah Bandan on 01/03/1441 AH.
//  Copyright © 1441 AbdullahBandan. All rights reserved.
//

import Foundation

struct FlickerRespones: Codable {
    let stat: String
    let code: Int
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case stat
        case code
        case message
    }
}

extension FlickerRespones: LocalizedError {
    var errorDescription: String? {
        return message
    }
}
