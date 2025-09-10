import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    var placeholder: String
    
    var body: some View {
        TextField(text: $text) {
            Text("\(placeholder)")
                .foregroundStyle(.black.opacity(0.7))
        }
        .padding()
        .background {
            Capsule()
                .fill(Color.gray.opacity(0.2))
        }
    }
}
