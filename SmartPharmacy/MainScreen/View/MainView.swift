import SwiftUI

// Основной экран, здесь показывается список лекарств

struct MainView: View {
    
    @StateObject var viewModel: MainViewModel = MainViewModel()
    
    var body: some View {
        
        VStack {
            ScrollView {
                ForEach($viewModel.drugs.indices, id: \.self) { ind in
                    DrugItem(drug: $viewModel.drugs[ind])
                }
            }
        }
        .padding()
    }
}

#Preview {
    MainView()
}
