import SwiftUI
import Charts

struct RecordView: View {
    @AppStorage ("mealRecord") private var mealRecordsData: Data = Data()
    
    private var records: [MealRecord] {
        (try? JSONDecoder().decode([MealRecord].self, from: mealRecordsData)) ?? []
    }

    struct MealRecord: Codable, Identifiable {
        var id: UUID = UUID()
        var date: Date
        var result: String
    }
    var body: some View {
        VStack{
            Chart(Data, id: \.mealRecordsData) { Data in
                SectorMark(
                    angle: .value("d", Data.sales),
                    angularInset: 1
                )
                .foregroundStyle(by: .value("a", Data.mealRecordsData))
            }
            .frame(height: 200)
            
            List(records.reversed()) { record in
                VStack(alignment: .leading, spacing: 4) {
                    Text(record.date, style: .date)
                        .font(.caption)
                        .foregroundStyle(.gray)
                    Text(record.result)
                        .font(.body)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle(Text("食事記録"))
            .overlay {
                if records.isEmpty {
                    Text("記録がありません")
                        .foregroundStyle(.gray)
                }
            }
        }
    }
}
