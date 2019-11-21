//
//  Speed.swift
//  SwiftSky
//
//  Created by Luca Silverentand on 11/04/2017.
//  Copyright © 2017 App Company.io. All rights reserved.
//

import Foundation

/// Contains a value, unit and a label describing speed
public struct Speed {
    
    /// `Double` representing speed
    private(set) public var value : Double = 0
    
    /// `SpeedUnit` of the value
    public let unit : SpeedUnit
    
    /// Human-readable representation of the value and unit together
    public var label : String {
        return label(as: unit)
    }
    
    /**
     Same as `Speed.label`, but converted to a specific unit
     
     - parameter unit: `SpeedUnit` to convert label to
     - returns: String
     */
    public func label(as unit : SpeedUnit) -> String {
        let converted = (self.unit == unit ? value : convert(value, from: self.unit, to: unit))
        switch unit {
        case .milePerHour:
            return "\(converted.noDecimal) mph"
        case .kilometerPerHour:
            return "\(converted.noDecimal) kph"
        case .meterPerSecond:
            return "\(converted.oneDecimal) m/s"
        case .knot:
            return "\(converted.twoDecimal) kt"
        case .beaufort:
            return "\(converted.noDecimal) bft"
        }
    }
    
    /**
     Same as `Speed.value`, but converted to a specific unit
     
     - parameter unit: `SpeedUnit` to convert value to
     - returns: Float
     */
    public func value(as unit : SpeedUnit) -> Double {
        return convert(value, from: self.unit, to: unit)
    }
    
    private func convert(_ value : Double, from : SpeedUnit, to : SpeedUnit) -> Double {
        switch from {
        case .milePerHour:
            switch to {
            case .milePerHour:
                return value
            case .kilometerPerHour:
                return value * 1.609344
            case .meterPerSecond:
                return value * 0.44704
            case .knot:
                return value / 1.150779
            case .beaufort:
                return beaufort(value, from: from)
            }
        case .kilometerPerHour:
            switch to {
            case .kilometerPerHour:
                return value
            case .milePerHour:
                return value / 1.609344
            case .meterPerSecond:
                return value / 3.6
            case .knot:
                return value / 1.852
            case .beaufort:
                return beaufort(value, from: from)
            }
        case .meterPerSecond:
            switch to {
            case .meterPerSecond:
                return value
            case .milePerHour:
                return value / 0.44704
            case .kilometerPerHour:
                return value * 3.6
            case .knot:
                return value * 1.9438444924406
            case .beaufort:
                return beaufort(value, from: from)
            }
        case .knot:
            switch to {
            case .knot:
                return value
            case .milePerHour:
                return value * 1.150779
            case .kilometerPerHour:
                return value * 1.852
            case .meterPerSecond:
                return value / 1.9438444924406
            case .beaufort:
                return beaufort(value, from: from)
            }
        default:
            // cannot convert from beaufort to an actual value
            return value
        }
    }
    
    private let bftSpeeds : [Double] = [1,7,12,20,31,40,51,62,75,88,103,118,178,250,333,419]
    private func beaufort(_ value: Double, from: SpeedUnit) -> Double {
        let kph = convert(value, from: from, to: .kilometerPerHour)
        for (i,speed) in bftSpeeds.enumerated() {
            if kph >= speed { return Double(i + 1) }
        }
        return 0
    }
    
    /// :nodoc:
    public init(_ value : Double, withUnit : SpeedUnit) {
        unit = SwiftSky.units.speed
        self.value = convert(value, from: withUnit, to: unit)
    }
}
