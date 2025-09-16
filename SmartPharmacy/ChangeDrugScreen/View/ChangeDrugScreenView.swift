import SwiftUI

// Экран на котором можно добавить лекарство в список принимаемых лекарств

struct ChangeDrugView: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: MainViewModel
    @State private var count: String = ""
    @State private var need: String = ""
    @Binding var drug: DrugModel

    var body: some View {
        VStack {
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Название лекарства:")
                CustomTextField(text: $drug.name, placeholder: "Название лекарства")
                
                Text("Уже выпито:")
                CustomTextField(text: $count, placeholder: "Сколько уже выпито")
                
                Text("Нужно выпить:")
                CustomTextField(text: $need, placeholder: "Сколько нужно выпить")
                    .keyboardType(.numberPad)
            }
            .foregroundStyle(.black)
            
            Spacer()
                .frame(height: UIScreen.main.bounds.height * 0.05)
            
            Button {
                if !drug.name.isEmpty || !need.isEmpty {
                    drug.need = Int(need) ?? 0
                    drug.count = Int(count) ?? 0
                    viewModel.changeDrug(drug: drug)
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
        .onAppear {
            count = String(drug.count)
            need = String(drug.need)
        }
    }
}

#Preview {
    @StateObject var viewModel = MainViewModel()
    @State var drug = DrugModel(name: "Акнетрент", count: 10, need: 30)
    ChangeDrugView(viewModel: viewModel, drug: $drug)
}
