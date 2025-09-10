import Foundation

struct DrugModel: Identifiable, Hashable {
    var id: UUID = UUID()
    var name: String
    var count: Int
    var need: Int
    
    mutating func increaseCount() {
        count += 1
    }
    
    mutating func decreaseCount() {
        count -= 1
    }
}
