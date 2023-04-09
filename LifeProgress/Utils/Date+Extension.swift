//
//  Date+Extension.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 08/04/2023.
//

import Foundation

extension Date {
    
    var endOfDay: Date {
        Calendar.current.dateInterval(of: .day, for: self)!.end
    }
}
