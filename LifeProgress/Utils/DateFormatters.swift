//
//  DateFormatters.swift
//  LifeProgress
//
//  Created by Bartosz Król on 12/03/2023.
//

import Foundation

enum DateFormatters {
    
    static let medium: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
}
