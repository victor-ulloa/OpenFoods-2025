//
//  String+Extension.swift
//  OpenFoods
//
//  Created by Victor Ulloa on 2025-11-08.
//

extension String {
    var flagEmoji: String {
        self
            .uppercased()
            .unicodeScalars
            .compactMap { UnicodeScalar(127397 + $0.value) }
            .map { String($0) }
            .joined()
    }
    
    var countryFlag: String {
        count == 2 ? flagEmoji : self
    }
}
