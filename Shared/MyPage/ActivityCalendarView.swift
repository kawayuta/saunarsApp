//
//  ActivityCalendarView.swift
//  saucialApp
//
//  Created by kawayuta on 5/12/21.
//

import SwiftUI
import FSCalendar

struct ActivityCalendarView: UIViewRepresentable {
    
    var calendar = FSCalendar()
    var activities_month: [Activity]
    
    init (activities_month: [Activity]) {
        self.activities_month = activities_month
    }
    
    func makeUIView(context: UIViewRepresentableContext<ActivityCalendarView>) -> FSCalendar {
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        initCalendar()
        return calendar
    }
    
    private func initCalendar() {
        calendar.appearance.todayColor = UIColor.systemGreen
        calendar.appearance.selectionColor = UIColor.systemBlue
        calendar.scope = .week
        calendar.appearance.headerDateFormat = "YYYY年（ww週目）MM月"
        calendar.calendarWeekdayView.weekdayLabels[0].text = "日"
        calendar.calendarWeekdayView.weekdayLabels[1].text = "月"
        calendar.calendarWeekdayView.weekdayLabels[2].text = "火"
        calendar.calendarWeekdayView.weekdayLabels[3].text = "水"
        calendar.calendarWeekdayView.weekdayLabels[4].text = "木"
        calendar.calendarWeekdayView.weekdayLabels[5].text = "金"
        calendar.calendarWeekdayView.weekdayLabels[6].text = "土"
    }
    
    func updateUIView(_ uiViewController: FSCalendar, context: UIViewRepresentableContext<ActivityCalendarView>) {
    
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self, activities_month: activities_month)
    }
    
    final class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
        private var parent: ActivityCalendarView
        var activities_month: [Activity]
        
        init (_ parent: ActivityCalendarView, activities_month: [Activity]) {
            self.activities_month = activities_month
            self.parent = parent
        }
        func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
            var image = UIImage(systemName: "link")
            
            let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy/MM/dd"
                    formatter.calendar = Calendar(identifier: .gregorian)
                    formatter.timeZone = TimeZone.current
                    formatter.locale = Locale.current
            
            print(11111)
//            if activities_month.contains(where: {DateUtils.dateFromString(string: $0.created_at!, format: "yyyy/MM/dd") == date}) {
//                image = UIImage(systemName: "heart")
//            }
            
            return image
        }
    }
}


class DateUtils {
    class func dateFromString(string: String, format: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.date(from: string)!
    }

    class func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}
