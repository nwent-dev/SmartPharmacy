import SwiftUI

// Основной экран, здесь показывается список лекарств

struct MainView: View {
    
    @StateObject var viewModel: MainViewModel = MainViewModel()
    
    var body: some View {
        
        NavigationView {
            VStack {
                ScrollView {
                    ForEach($viewModel.drugs.indices, id: \.self) { ind in
                        DrugItem(drug: $viewModel.drugs[ind])
                    }
                }
            }
            .padding()
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        AddDrugView(viewModel: viewModel)
                    } label: {
                        HStack{
                            Text("Добавить")
                                .foregroundStyle(.black)
                                .font(.headline)
                            Image(systemName: "plus.circle")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.black)
                                .frame(width: UIScreen.main.bounds.width * 0.07)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    MainView()
}
