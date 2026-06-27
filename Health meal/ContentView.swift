import SwiftUI

struct ContentView: View {
    var body: some View {
            TabView {
                Tab("ホーム", systemImage: "house.fill"){
                    HomeView()
                }
                Tab("カレンダー", systemImage: "calendar"){
                    CalendarView()
                }
                Tab("履歴", systemImage: "clock.fill"){
                    RecordView()
                }
                Tab("設定", systemImage: "gearshape"){
                    SettingView()
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
