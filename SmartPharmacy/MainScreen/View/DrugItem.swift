import SwiftUI

// DrugItem - элемент списка(принимаемое лекарство)
struct DrugItem: View {
    @Binding var drug: DrugModel
    
    var body: some View {
        HStack {
            VStack {
                Text("\(drug.name)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    Text("Применено (в днях): \(drug.count) / \(drug.need)")
                    
                }
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
    }
}

#Preview {
    @State var drug = DrugModel(name: "Aknetrent", count: 10, need: 30)
    DrugItem(drug: $drug)
}
