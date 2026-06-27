import SwiftUI
import UIKit

struct CalendarModelView: UIViewRepresentable {
    @AppStorage("mealRecords") private var mealRecordsData: Data = Data()
    
    func makeUIView(context: Context) -> UICalendarView{
        let calendarView = UICalendarView()
        
        calendarView.calendar = Calendar(identifier: .gregorian)
        calendarView.locale = Locale(identifier: "ja_JP")
        calendarView.delegate = context.coordinator
        return calendarView
    }
    func updateUIView(_ uiView: UICalendarView, context: Context) {
        //データを更新したら装飾する
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    class Coordinator: NSObject, UICalendarViewDelegate {
        let parent: CalendarModelView
        
        init(_ parent: CalendarModelView) {
            self.parent = parent
            super.init()
        }
        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            let data = parent.mealRecordsData
            
            guard let meals = try? JSONDecoder().decode([MealRecord].self, from: data
            )else {
                return nil
            }
            
            guard let targetData =
                    Calendar.current.date(from: dateComponents
                    )else {
                return nil
            }
            
            let hasRecord = meals.contains { meal in
                Calendar.current.isDate(
                    meal.date,
                    inSameDayAs: targetData
                )
            }
            
            if !hasRecord {
                return nil
            }
            return .customView {
                let data = self.parent.mealRecordsData
                print(data)
            return UILabel()
            }
        }
    }

}

#Preview {
    CalendarModelView()
}
