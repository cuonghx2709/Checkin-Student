//
//  Double+.swift
//  Checkin-Student
//
//  Created by cuong hoang on 5/23/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    func customDescription () -> String {
        return String(format:"%.5f", self)
    }
    func roundDouble(num: Double) -> Float {
        
        //Create NSDecimalNumberHandler to specify rounding behavior
        let numHandler = NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode.down, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        
        let roundedNum = NSDecimalNumber(value: num).rounding(accordingToBehavior: numHandler)
        
        //Convert to float so you don't get the endless repeating decimal.
        return Float(truncating: roundedNum)
    }

}
