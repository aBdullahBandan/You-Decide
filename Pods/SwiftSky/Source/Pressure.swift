//
//  Pressure.swift
//  SwiftSky
//
//  Created by Luca Silverentand on 16/04/2017.
//
//

import Foundation

/// Contains a value, unit and a label describing atmospheric pressure
public struct Pressure {
    
    /// `Double` representing atmospheric pressure
    private(set) public var value : Double = 0
    
    /// `PressureUnit` of the value
    public let unit : PressureUnit
    
    /// Human-readable representation of the value and unit together
    public var label : String { return label(as: unit) }
    
    /**
     Same as `Pressure.label`, but converted to a specific unit
     
     - parameter unit: `PressureUnit` to convert label to
     - returns: String
     */
    public func label(as unit : PressureUnit) -> String {
        let converted = (self.unit == unit ? value : convert(value, from: self.unit, to: unit))
        switch unit {
        case .millibar:
            return "\(converted.noDecimal) mb"
        case .hectopascal:
            return "\(converted.noDecimal) hPa"
        case .inchesOfMercury:
            return "\(converted.oneDecimal) inHg"
        }
    }
    
    /**
     Same as `Pressure.value`, but converted to a specific unit
     
     - parameter unit: `PressureUnit` to convert value to
     - returns: Float
     */
    public func value(as unit : PressureUnit) -> Double {
        return convert(value, from: self.unit, to: unit)
    }
    
    private func convert(_ value : Double, from : PressureUnit, to : PressureUnit) -> Double {
        switch from {
        case .millibar:
            switch to {
            case .millibar:
                return value
            case .hectopascal:
                return value
            case .inchesOfMercury:
                return value * 0.02953
            }
        case .hectopascal:
            switch to {
            case .hectopascal:
                return value
            case .millibar:
                return value
            case .inchesOfMercury:
                return value * 0.02953
            }
        case .inchesOfMercury:
            switch to {
            case .inchesOfMercury:
                return value
            case .millibar:
                return value / 0.02953
            case .hectopascal:
                return value / 0.02953
            }
        }
    }
    
    /// :nodoc:
    public init(_ value : Double, withUnit : PressureUnit) {
        unit = SwiftSky.units.pressure
        self.value = convert(value, from: withUnit, to: unit)
    }
}
