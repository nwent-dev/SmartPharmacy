import SwiftUI

// Экран на котором можно изменить лекарство в списке принимаемых лекарств

struct ChangeDrugView: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: MainViewModel
    @Binding var drug: DrugModel
    
    @State private var name: String = ""
    @State private var count: String = ""
    @State private var need: String = ""
    @State private var isAnimating: Bool = false
    
    private var isValid: Bool {
        let needValue = Int(need) ?? -1
        let countValue = Int(count) ?? -1
        return !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && needValue >= 0
        && countValue >= 0
        && countValue <= needValue // базовая проверка: выпито не больше нужного
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Заголовок
                VStack(spacing: 8) {
                    HStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color.blue.opacity(0.7), Color.cyan.opacity(0.5)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 54, height: 54)
                            Image(systemName: "pills.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                                .foregroundStyle(.white)
                                .shadow(radius: 2)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Изменить лекарство")
                                .font(.title2.weight(.bold))
                                .foregroundStyle(.primary)
                            Text("Обновите название и параметры приёма")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                // Карточка формы
                VStack(spacing: 18) {
                    LabeledField(
                        title: "Название",
                        systemImage: "textformat",
                        placeholder: "Например: Акнетрент",
                        text: $name,
                        keyboard: .default
                    )
                    
                    Divider().opacity(0.2)
                    
                    LabeledField(
                        title: "Уже выпито (дней)",
                        systemImage: "checkmark.circle",
                        placeholder: "Например: 10",
                        text: $count,
                        keyboard: .numberPad
                    )
                    
                    Divider().opacity(0.2)
                    
                    LabeledField(
                        title: "Нужно выпить (дней)",
                        systemImage: "calendar",
                        placeholder: "Например: 30",
                        text: $need,
                        keyboard: .numberPad
                    )
                }
                .padding(18)
                .background(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(.systemBackground),
                                    Color.blue.opacity(0.03)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 6)
                )
                .padding(.horizontal)
                .padding(.top, 4)
                
                // Подсказка валидации
                if !isValid {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(.yellow)
                        Text("Проверьте поля: название, числа ≥ 0, выпито не больше нужного.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
                
                // Кнопка Сохранить
                Button(action: saveAction) {
                    HStack(spacing: 10) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title3.weight(.semibold))
                        Text("Сохранить")
                            .font(.headline)
                    }
                    .padding(.vertical, 14)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .background(
                        LinearGradient(
                            colors: [Color.cyan, Color.blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: Color.blue.opacity(isValid ? 0.25 : 0.0), radius: 10, y: 6)
                    .scaleEffect(isAnimating ? 0.98 : 1.0)
                    .animation(.spring(response: 0.35, dampingFraction: 0.7), value: isAnimating)
                }
                .disabled(!isValid)
                .opacity(isValid ? 1.0 : 0.6)
                .padding(.horizontal)
                .padding(.bottom, 8)
                
                // Кнопка отмены
                Button(role: .cancel) {
                    dismiss()
                } label: {
                    Text("Отмена")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
                .padding(.bottom, 16)
            }
            .padding(.top, 12)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("Изменить")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Spacer()
                    Button("Готово") {
                        hideKeyboard()
                    }
                    .font(.body.weight(.semibold))
                }
            }
        }
        .onAppear {
            // Заполнить поля текущими значениями
            name = drug.name
            count = String(drug.count)
            need = String(drug.need)
        }
    }
    
    private func saveAction() {
        guard isValid else { return }
        isAnimating = true
        
        var updated = drug
        updated.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        updated.count = Int(count) ?? updated.count
        updated.need = Int(need) ?? updated.need
        
        viewModel.changeDrug(drug: updated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            isAnimating = false
            dismiss()
        }
    }
    
    private func hideKeyboard() {
        #if canImport(UIKit)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        #endif
    }
}

// Вспомогательное поле с иконкой и заголовком
private struct LabeledField: View {
    let title: String
    let systemImage: String
    let placeholder: String
    @Binding var text: String
    var keyboard: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                Image(systemName: systemImage)
                    .font(.headline)
                    .foregroundStyle(.blue)
                    .frame(width: 22)
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                Spacer()
            }
            TextField(placeholder, text: $text)
                .textInputAutocapitalization(.words)
                .disableAutocorrection(true)
                .keyboardType(keyboard)
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.gray.opacity(0.12))
                )
        }
    }
}

#Preview {
    @StateObject var viewModel = MainViewModel()
    @State var drug = DrugModel(name: "Акнетрент", count: 10, need: 30)
    return NavigationView {
        ChangeDrugView(viewModel: viewModel, drug: $drug)
    }
}
