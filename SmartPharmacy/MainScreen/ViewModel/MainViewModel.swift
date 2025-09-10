import Foundation

class MainViewModel: ObservableObject {
    @Published var drugs: [DrugModel] = [DrugModel(name: "Aknetrent", count: 10, need: 30)]
    
    func addDrug(drug: DrugModel) {
        drugs.append(drug)
    }
    
    func changeDrug(drug: DrugModel) {
        drugs = drugs.map { $0.id == drug.id ? drug : $0 }
    }
}
