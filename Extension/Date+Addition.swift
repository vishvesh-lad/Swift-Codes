//
//  Date+Addition.swift
//
//  Created by Vicky Prajapati.
//

import Foundation

extension Date {
    // get today
    func getToday() -> Date? {
        return Date()
    }
    // get yesterday
    func getYesterday() -> Date? {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)
    }
    // get tommorow
    func getTommorow() -> Date? {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)
    }
    // get Seven day before date
    func getSevenDayBeforeDate() -> Date? {
        return Calendar.current.date(byAdding: .day, value: -7, to: self)
    }
    // This Week Start date
    func getThisWeekStartDate() -> Date? {
        return  Calendar.current.date(byAdding: .day, value: -(Calendar.current.component(.weekday, from: self) - 1), to: self)
    }
    
    // Last Week Start date
    func getLastWeekStartDate() -> Date? {
        return Calendar.current.date(byAdding: .day, value: -7, to: getThisWeekStartDate() ?? self)
    }
    
    // Last Week End date
    func getLastWeekEndDate() -> Date? {
        return Calendar.current.date(byAdding: .day, value: -1, to: getThisWeekStartDate() ?? self)
    }
    
    //Last Month Start
    func getLastMonthStartDate() -> Date? {
        let components:NSDateComponents = Calendar.current.dateComponents([.year, .month], from: self) as NSDateComponents
        components.month -= 1
        return Calendar.current.date(from: components as DateComponents)!
    }
    
    //Last Month End
    func getLastMonthEndDate() -> Date? {
        let components:NSDateComponents = Calendar.current.dateComponents([.year, .month], from: self) as NSDateComponents
        components.day = 1
        components.day -= 1
        return Calendar.current.date(from: components as DateComponents)!
    }
    
    // get start time stamp
    func getStartTimeStamp(date: Date?) -> Int {
        let dateString = DateFormatter.dateformatter(withformat: DateFormatterList.yyyyMMdd).string(from: date ?? Date() ) + " 00:00:00"
        let newDate = DateFormatter.dateformatter(withformat: .yyyyMMddHHmmss).date(from: dateString)
        return Int(newDate?.timeIntervalSince1970 ?? 0)
    }
     // get end time stamp
    func getEndTimeStamp(date: Date?) -> Int {
        let dateString = DateFormatter.dateformatter(withformat: DateFormatterList.yyyyMMdd).string(from: date ?? Date() ) + " 23:59:59"
        let newDate = DateFormatter.dateformatter(withformat: .yyyyMMddHHmmss).date(from: dateString)
        return Int(newDate?.timeIntervalSince1970 ?? 0)
    }
    
    func getTotalDaysOfMonth(month: String) -> Int{
        let dateComponents = DateComponents(month: Int(month))
        let date = Calendar.current.date(from: dateComponents)
        let range = Calendar.current.range(of: .day, in: .month, for: date!)
        let numDays = range!.count
        return numDays
    }
    
    // interval days between two dates
    func interval(ofComponent comp: Calendar.Component, startDate: Date?, endDate: Date?) -> Int {
        let currentCalendar = Calendar.current
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: startDate ?? self) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: endDate ?? self) else { return 0 }
        return end - start
    }
    
    //Compare dates
    func isCurrentDateAfter(date: Date) -> Bool{
        //Check current date is after
        if Calendar.current.compare(self, to: date, toGranularity: .day) == .orderedDescending{
            return true
        }
        return false
    }
}
