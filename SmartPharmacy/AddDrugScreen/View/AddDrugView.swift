import SwiftUI

// Экран на котором можно добавить лекарство в список принимаемых лекарств

struct AddDrugView: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: MainViewModel
    
    @State private var drugName: String = ""
    @State private var need: String = ""
    @State private var allOk: Bool = false

    var body: some View {
        VStack {
            
            Spacer()
            
            CustomTextField(text: $drugName, placeholder: "Название лекарства")
            CustomTextField(text: $need, placeholder: "Сколько нужно выпить")
                .keyboardType(.numberPad)
            
            Spacer()
                .frame(height: UIScreen.main.bounds.height * 0.05)
            
            Button {
                if !drugName.isEmpty || !need.isEmpty {
                    viewModel.addDrug(drug: DrugModel(name: drugName, count: 0, need: Int(need) ?? 0))
                    dismiss()
                } else {
                    print("Что-то не введнео")
                }
            } label: {
                Text("Добавить")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.cyan)
                    .cornerRadius(30)
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

#Preview {
    @StateObject var viewModel = MainViewModel()
    AddDrugView(viewModel: viewModel)
}
