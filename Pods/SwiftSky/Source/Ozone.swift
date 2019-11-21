//
//  Ozone.swift
//  SwiftSky
//
//  Created by Luca Silverentand on 16/04/2017.
//
//

import Foundation

/// Columnar density of total atmospheric ozone in Dobson units
public struct Ozone {
    
    /// `Double` representing atmospheric ozone
    public let value : Double
    
    /// Human-readable representation of the atmospheric ozone
    public let label : String
    
    /// :nodoc:
    public init(_ value: Double) {
        self.value = value
        self.label = "\(value.noDecimal) DU"
    }
}
