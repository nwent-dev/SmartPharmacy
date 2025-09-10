import SwiftUI

// DrugItem - элемент списка(принимаемое лекарство)
struct DrugItem: View {
    @Binding var drug: DrugModel
    
    var body: some View {
        HStack {
            VStack {
                Text("\(drug.name)")
                    .font(.title2)
                    .foregroundStyle(.black.opacity(0.8))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Применено (в днях): \(drug.count) / \(drug.need)")
                    .font(.headline)
                    .foregroundStyle(.black.opacity(0.8))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Button {
                drug.count > 0 ? drug.decreaseCount() : nil
            } label: {
                Image(systemName: "minus.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.07)
                    .foregroundStyle(.black)
            }
            
            Button {
                drug.increaseCount()
            } label: {
                Image(systemName: "plus.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.07)
                    .foregroundStyle(.black)
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.gray.opacity(0.2))
        }
    }
}

#Preview {
    @State var drug = DrugModel(name: "Aknetrent", count: 10, need: 30)
    DrugItem(drug: $drug)
}
