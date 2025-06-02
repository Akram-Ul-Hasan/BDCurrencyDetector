//
//  NumberFormatter + Extensions.swift
//  BDCurrencyDetector
//
//  Created by Akram Ul Hasan on 2/6/25.
//

import Foundation

extension NumberFormatter {
    
    static var percentage: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
}
