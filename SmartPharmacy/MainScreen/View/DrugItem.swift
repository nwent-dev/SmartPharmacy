import SwiftUI

// DrugItem - элемент списка (принимаемое лекарство)
struct DrugItem: View {
    @Binding var drug: DrugModel
    @State private var animateCount = false

    var body: some View {
        HStack(spacing: 16) {
            // Иконка лекарства
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.blue.opacity(0.7), Color.cyan.opacity(0.5)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: iconSize, height: iconSize)
                    .accessibilityHidden(true)
                Image(systemName: "pills.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: iconSize * 0.54, height: iconSize * 0.54)
                    .foregroundStyle(.white)
                    .shadow(radius: 2)
                    .accessibilityLabel(Text("Лекарство"))
            }
            .padding(.trailing, 4)

            VStack(alignment: .leading, spacing: 6) {
                Text(drug.name)
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .layoutPriority(2)
                    .accessibilityLabel(Text("Название лекарства: \(drug.name)"))

                HStack(spacing: 2) {
                    Text("Применено:")
                        .font(.callout.weight(.medium))
                        .foregroundStyle(.secondary)
                        .accessibilityHidden(true)
                    Text("\(drug.count)")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(.blue)
                        .scaleEffect(animateCount ? 1.22 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.5), value: animateCount)
                        .accessibilityLabel(Text("Приёмов: \(drug.count)"))
                    Text("/")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .accessibilityHidden(true)
                    Text("\(drug.need)")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .accessibilityLabel(Text("Нужно: \(drug.need)"))
                    Text("дн.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .accessibilityHidden(true)
                }
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // Кнопка минус
            Button {
                if drug.count > 0 {
                    drug.decreaseCount()
                    withAnimation { animateCount = true }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                        animateCount = false
                    }
                }
            } label: {
                Image(systemName: "minus.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: buttonSize, height: buttonSize)
                    .foregroundStyle(drug.count > 0 ? Color.red : Color.gray.opacity(0.5))
                    .shadow(color: drug.count > 0 ? Color.red.opacity(0.18) : .clear, radius: 4, y: 2)
                    .scaleEffect(drug.count > 0 ? 1.0 : 0.96)
                    .opacity(drug.count > 0 ? 1.0 : 0.5)
                    .accessibilityLabel(Text("Уменьшить количество"))
            }
            .buttonStyle(.plain)
            .disabled(drug.count == 0)
            .padding(.horizontal, 2)

            // Кнопка плюс
            Button {
                drug.increaseCount()
                withAnimation { animateCount = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                    animateCount = false
                }
            } label: {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: buttonSize, height: buttonSize)
                    .foregroundStyle(Color.green)
                    .shadow(color: Color.green.opacity(0.18), radius: 4, y: 2)
                    .accessibilityLabel(Text("Увеличить количество"))
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 2)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(.systemBackground),
                            Color.blue.opacity(0.14)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: Color.black.opacity(0.08), radius: 7, x: 0, y: 4)
        )
        .padding(.horizontal)
        .accessibilityElement(children: .combine)
    }

    // Размеры с учётом Dynamic Type, но с минимальными и максимальными ограничениями
    private var iconSize: CGFloat {
        let base = UIFont.preferredFont(forTextStyle: .title3).pointSize * 2
        return min(max(base, 44), 70)
    }
    private var buttonSize: CGFloat {
        let base = UIFont.preferredFont(forTextStyle: .title2).pointSize * 1.4
        return min(max(base, 32), 48)
    }
}

#Preview {
    @State var drug = DrugModel(name: "Aknetrent", count: 10, need: 30)
    DrugItem(drug: $drug)
}
