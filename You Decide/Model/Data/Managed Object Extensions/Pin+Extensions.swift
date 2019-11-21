//
//  Pin+Extensions.swift
//  You Decide
//
//  Created by Abdullah Bandan on 05/03/1441 AH.
//  Copyright © 1441 AbdullahBandan. All rights reserved.
//

import Foundation
import CoreData
import MapKit

extension Pin: MKAnnotation {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
    }
    public var coordinate: CLLocationCoordinate2D {
        return .init(latitude: .init(lat), longitude: .init(lon))
    }
    
    
}
