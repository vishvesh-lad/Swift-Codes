//
//  DateFormatter+Addition.swift
//
//  Created by Vicky Prajapati.
//

import Foundation

enum DateFormatterList : String {
    case yyyyMMddHHmmss = "yyyy-MM-dd HH:mm:ss",
    yyyyMMdd = "yyyy-MM-dd",
    HHmmss = "HH:mm:ss",
    hhmma = "hh:mm a",
    hmma = "h:mm a",
    ddMMyyyy = "dd/MM/yyyy",
    ddMMMyyyy = "dd MMM yyyy",
    yyyyMMddTHHmmssSZ = "yyyy-MM-dd'T'HH:mm:ss.SZ",
    ddMMyyyyhhmma = "dd/MM/yyyy hh:mm a",
    yy = "yy"
}

extension DateFormatter {
    class func dateformatter(withformat: DateFormatterList) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = withformat.rawValue
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }
}
