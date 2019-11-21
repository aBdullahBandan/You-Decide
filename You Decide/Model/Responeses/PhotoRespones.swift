//
//  PhotoUrlRespones.swift
//  You Decide
//
//  Created by Abdullah Bandan on 02/03/1441 AH.
//  Copyright © 1441 AbdullahBandan. All rights reserved.
//

import Foundation

// MARK: - PhotoRespones
struct PhotoRespones: Codable {
    let photos: Photos
    }

    // MARK: - Photos
    struct Photos: Codable {
        let photo: [PhotoLocal]
    }
