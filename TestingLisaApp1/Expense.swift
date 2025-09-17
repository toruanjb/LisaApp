import Foundation

struct Expense: Identifiable, Codable {
    let id: UUID
    let amount: Double
    let category: ExpenseCategory
    let date: Date
    let notes: String?
    
    init(amount: Double, category: ExpenseCategory, date: Date, notes: String? = nil) {
        self.id = UUID()
        self.amount = amount
        self.category = category
        self.date = date
        self.notes = notes
    }
    
    init(id: UUID, amount: Double, category: ExpenseCategory, date: Date, notes: String? = nil) {
        self.id = id
        self.amount = amount
        self.category = category
        self.date = date
        self.notes = notes
    }
}

enum ExpenseCategory: String, CaseIterable, Codable {
    case food = "Food"
    case transportation = "Transportation"
    case clothes = "Clothes"
    
    var icon: String {
        switch self {
        case .food: return "fork.knife"
        case .transportation: return "car"
        case .clothes: return "tshirt"
        }
    }
}
