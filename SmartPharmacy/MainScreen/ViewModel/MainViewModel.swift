import Foundation
import Combine

class MainViewModel: ObservableObject {
    @Published var drugs: [DrugModel] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let storageKey = "drugs_storage_key_v1"
    
    init() {
        load()
        
        // Автосохранение при любом изменении массива (подстраховка)
        $drugs
            .dropFirst() // пропустить начальное значение из load()
            .sink { [weak self] newValue in
                self?.save()
            }
            .store(in: &cancellables)
    }
    
    func addDrug(drug: DrugModel) {
        drugs.append(drug)
        save() // явное сохранение
    }
    
    func changeDrug(drug: DrugModel) {
        drugs = drugs.map { $0.id == drug.id ? drug : $0 }
        save() // явное сохранение
    }
    
    func remove(at offsets: IndexSet) {
        drugs.remove(atOffsets: offsets)
        save() // явное сохранение
    }
    
    func remove(id: UUID) {
        if let idx = drugs.firstIndex(where: { $0.id == id }) {
            drugs.remove(at: idx)
            save()
        }
    }
    
    // MARK: - Persistence
    
    private func save() {
        do {
            let data = try JSONEncoder().encode(drugs)
            UserDefaults.standard.set(data, forKey: storageKey)
            // Лог успешного сохранения
            #if DEBUG
            print("Saved \(drugs.count) drugs to UserDefaults")
            #endif
        } catch {
            print("Save error: \(error)")
        }
    }
    
    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            self.drugs = []
            return
        }
        do {
            let decoded = try JSONDecoder().decode([DrugModel].self, from: data)
            self.drugs = decoded
        } catch {
            self.drugs = []
        }
    }
}
