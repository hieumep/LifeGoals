//
//  ExtendDate.swift
//  Life Goals
//
//  Created by Hieu Vo on 2/24/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import Foundation

extension Date {
    func formatDateToString() -> String {
        let dateFormater = DateFormatter()
        dateFormater.locale = Locale.current
        dateFormater.dateStyle = .short
        let dateString = dateFormater.string(from: self)
        return dateString
    }
    
    func getTomorrow() -> Date {
        let tomorrow = NSCalendar.current.date(byAdding: .day, value: 1, to: self)
        return tomorrow!
    }
    
    func formatShortDateToString() -> String{
        let calendar = Calendar(identifier: .gregorian)
        let dateComponents = calendar.dateComponents([.day,.month,.year], from: self)
        var dateFormat = ""
        dateFormat = "\(dateComponents.month!)" + "/\(dateComponents.day!)" + "/\(dateComponents.year!)"
        print(dateFormat)
        return dateFormat
    }

}
