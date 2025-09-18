import SwiftUI

// Основной экран, здесь показывается список лекарств

struct MainView: View {
    
    @StateObject var viewModel: MainViewModel = MainViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.drugs.isEmpty {
                    VStack(spacing: 24) {
                        Spacer()
                        Image(systemName: "pills.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundStyle(.blue.opacity(0.18))
                        Text("Нет лекарств")
                            .font(.title2.weight(.semibold))
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemGroupedBackground))
                } else {
                    List {
                        ForEach($viewModel.drugs.indices, id: \.self) { ind in
                            ZStack {
                                // Карточка
                                DrugItem(drug: $viewModel.drugs[ind])
                                    .padding(.vertical, 2)
                                
                                // Невидимая область для перехода без стрелки
                                NavigationLink {
                                    ChangeDrugView(viewModel: viewModel, drug: $viewModel.drugs[ind])
                                } label: {
                                    EmptyView()
                                }
                                .opacity(0) // скрыть "стрелку"
                            }
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    removeDrug(at: ind)
                                } label: {
                                    Label("Удалить", systemImage: "trash")
                                }
                            }
                        }
                        .onDelete(perform: removeDrugs)
                    }
                    .listStyle(.plain)
                    .scrollIndicators(.visible)
                    .scrollContentBackground(.hidden) // скрыть системный фон List
                    .background(Color(.systemGroupedBackground)) // общий фон экрана
                }
            }
            .navigationTitle("Мои лекарства")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        AddDrugView(viewModel: viewModel)
                    } label: {
                        HStack(spacing: 6) {
                            Text("Добавить")
                                .font(.headline)
                                .foregroundStyle(.tint)
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .foregroundStyle(.tint)
                                .padding(.leading, 2)
                        }
                        .contentShape(Rectangle())
                    }
                }
            }
            .background(Color(.systemGroupedBackground)) // на случай пустого состояния
        }
        .navigationViewStyle(.stack) // Опционально, для iPhone
    }
    
    private func removeDrug(at index: Int) {
        guard viewModel.drugs.indices.contains(index) else { return }
        viewModel.drugs.remove(at: index)
    }
    
    private func removeDrugs(at offsets: IndexSet) {
        viewModel.drugs.remove(atOffsets: offsets)
    }
}

#Preview {
    MainView()
}
