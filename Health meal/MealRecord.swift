import Foundation

struct MealRecord: Codable, Identifiable {
    var id: UUID = UUID()
    var date: Date
    var result: String
    
    
}
    

