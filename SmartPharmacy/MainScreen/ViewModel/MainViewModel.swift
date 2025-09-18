import Foundation
import Combine

class MainViewModel: ObservableObject {
    @Published var drugs: [DrugModel] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let storageKey = "drugs_storage_key_v1"
    
    init() {
        load()
        
        // Автосохранение при любом изменении массива
        $drugs
            .dropFirst() // пропустить начальное значение из load()
            .sink { [weak self] _ in
                self?.save()
            }
            .store(in: &cancellables)
    }
    
    func addDrug(drug: DrugModel) {
        drugs.append(drug)
    }
    
    func changeDrug(drug: DrugModel) {
        drugs = drugs.map { $0.id == drug.id ? drug : $0 }
    }
    
    // MARK: - Persistence
    
    private func save() {
        do {
            let data = try JSONEncoder().encode(drugs)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            print("Save error: \(error)")
        }
    }
    
    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            // Первичный пример, если хранилище пусто — можно оставить пустым
            self.drugs = []
            return
        }
        do {
            let decoded = try JSONDecoder().decode([DrugModel].self, from: data)
            self.drugs = decoded
        } catch {
            print("Load error: \(error)")
            self.drugs = []
        }
    }
}
