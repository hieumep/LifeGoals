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

}
