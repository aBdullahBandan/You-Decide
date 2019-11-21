//
//  Percentage.swift
//  SwiftSky
//
//  Created by Luca Silverentand on 16/04/2017.
//
//

import Foundation

/// Contains a value, 0 to 1 representation and label describing percentage
public struct Percentage {
    
    /// `Double` between 0.0 and 1.0 representing 0% and 100%, respectively
    public let zeroToOne : Double
    
    /// `Int` representing a percentage
    public let value : Int
    
    /// Human-readable representation of the percentage
    public let label : String
    
    /// :nodoc:
    init(_ value : Double) {
        zeroToOne = value
        self.value = Int(round(value * 100))
        label = "\(self.value)%"
    }
}
