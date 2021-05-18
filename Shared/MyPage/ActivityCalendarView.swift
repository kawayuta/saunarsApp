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
        calendar.calendarHeaderView.isHidden = true
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
            
            activities_month.map { item in
                let aa = formatter.date(from: item.created_at ?? "")
                print(aa)
                print(item.created_at)
                
            }
//            print(DateUtils.dateFromString(string: $0.created_at!)
            if activities_month.contains(where: {formatter.date(from: $0.created_at ?? "") == date}) {
                image = UIImage(systemName: "heart")
            }
            
            return image
        }
        
        
        func dateFormatStr(fmt: String, str: String ) -> Date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = fmt
            let date_to = dateFormatter.date(from: str)
            return date_to!
        }
    }
}

