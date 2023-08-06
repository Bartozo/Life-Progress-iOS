//
//  ShareLifeGoalView.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 02/08/2023.
//

import SwiftUI
import ComposableArchitecture

struct ShareLifeGoalView: View {
    
    @Environment(\.theme) var theme
    
    let store: ShareLifeGoalStore
    
    var body: some View {
        NavigationStack {
            WithViewStore(self.store, observe: \.theme) { viewStore in
                let theme = viewStore.state
                
                List {
                    Section {
                        ImagePreview(store: self.store)
                            .environment(\.colorScheme, theme == .dark ? .dark : .light)
                    }
                    .listRowInsets(EdgeInsets())
                    
                    Section {
                        ThemePicker(store: self.store)
                        ColorPickerView(
                            store: self.store.scope(
                                state: \.colorPicker,
                                action: ShareLifeGoalReducer.Action.colorPicker
                            )
                        )
                        TimeSwitch(store: self.store)
                        WatermarkSwitch(store: self.store)
                    }
                }
                .navigationTitle("Share Life Goal")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            viewStore.send(.closeButtonTapped)
                        } label: {
                            Text("Close")
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        ShareLink(
                            item: Image(uiImage: generateSnapshot(theme: theme)),
                            preview: SharePreview(
                                "Life Goal",
                                image: Image(uiImage: generateSnapshot(theme: theme))
                            )
                        )
                    }
                }
            }
        }
        .tint(theme.color)
    }
    
    @MainActor
    private func generateSnapshot(theme: ShareLifeGoalReducer.State.Theme) -> UIImage {
        let screenSize = UIScreen.main.bounds.size
        let imagePreview = ImagePreview(store: self.store)
            .frame(width: screenSize.width, height: screenSize.width)
            .environment(\.colorScheme, theme == .dark ? .dark : .light)
        let renderer = ImageRenderer(content: imagePreview)
        renderer.scale = UIScreen.main.scale
     
        return renderer.uiImage ?? UIImage()
    }
}

private struct ImagePreview: View {
    
    let store: ShareLifeGoalStore
    
    struct ViewState: Equatable {
        let lifeGoal: LifeGoal
        let theme: ShareLifeGoalReducer.State.Theme
        let color: ColorPickerReducer.State.Color
        let isTimeVisible: Bool
        let isWaterMarkVisible: Bool
        
        init(state: ShareLifeGoalReducer.State) {
            self.lifeGoal = state.lifeGoal
            self.theme = state.theme
            self.color = state.colorPicker.color
            self.isTimeVisible = state.isTimeVisible
            self.isWaterMarkVisible = state.isWatermarkVisible
        }
    }
    
    var body: some View {
        WithViewStore(self.store, observe: ViewState.init) { viewStore in
            ZStack {
                Rectangle()
                    .fill(viewStore.color.colorValue.gradient)
                
                VStack {
                    Image(systemName: viewStore.lifeGoal.symbolName)
                        .padding()
                        .background(in: Circle())
                        .foregroundStyle(.white.shadow(.drop(radius: 1, x: 2, y: 2)))
                        .backgroundStyle(viewStore.color.colorValue.gradient)
                        .font(.system(size: 60))
                        .padding(.bottom)
                    
                    VStack(alignment: .center) {
                        Text(viewStore.lifeGoal.title)
                            .lineLimit(2)
                            .font(.headline)
                        
                        Text(viewStore.lifeGoal.details)
                            .lineLimit(3)
                            .font(.footnote)
                            .padding(.horizontal)
                        
                        if viewStore.isTimeVisible {
                            Text(viewStore.lifeGoal.finishedAt!, style: .date)
                                .font(.footnote)
                                .padding(.top)
                        }
                    }
                    .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.thinMaterial)
                .cornerRadius(16)
                .padding()
                .padding()
            }
            .aspectRatio(1, contentMode: .fill)
            .overlay(
                 VStack {
                     if viewStore.isWaterMarkVisible {
                         Spacer()
                         HStack {
                             Spacer()
                             Text("Life Progress")
                                 .font(.footnote)
                         }
                     }
                 }
                 .padding(10)
                 .foregroundColor(.white)
             )
        }
    }
}

private struct ThemePicker: View {
    
    let store: ShareLifeGoalStore
    
    var body: some View {
        WithViewStore(self.store, observe: \.theme) { viewStore in
            Picker(
                "Theme",
                selection: viewStore.binding(
                    get: { $0 },
                    send: ShareLifeGoalReducer.Action.themeChanged
                )
                .animation()
            ) {
                ForEach(ShareLifeGoalReducer.State.Theme.allCases, id: \.self) { theme in
                    Text(theme.title)
                        .tag(theme)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}

private struct TimeSwitch: View {
    
    let store: ShareLifeGoalStore
    
    var body: some View {
        WithViewStore(self.store, observe: \.isTimeVisible) { viewStore in
            Toggle(
                "Show time",
                isOn: viewStore.binding(
                    get: { $0 },
                    send: ShareLifeGoalReducer.Action.isTimeVisibleChanged
                )
                .animation(.default)
            )
        }
    }
}

private struct WatermarkSwitch: View {
    
    let store: ShareLifeGoalStore
    
    var body: some View {
        WithViewStore(self.store, observe: \.isWatermarkVisible) { viewStore in
            Toggle(
                "Show watermark",
                isOn: viewStore.binding(
                    get: { $0 },
                    send: ShareLifeGoalReducer.Action.isWatermarkVisibleChanged
                )
                .animation(.default)
            )
        }
    }
}

// MARK: - Previews

struct ShareLifeGoalView_Previews: PreviewProvider {
    
    static var previews: some View {
        let store = Store<ShareLifeGoalReducer.State, ShareLifeGoalReducer.Action>(
            initialState: ShareLifeGoalReducer.State(
                lifeGoal: LifeGoal(
                    id: UUID(),
                    title: "Road Trip on Route 66",
                    finishedAt: Date.now,
                    symbolName: "trophy",
                    details: "Plan and embark on a memorable road trip across America's historic Route 66"
                )
            ),
            reducer: ShareLifeGoalReducer()
        )
        
        NavigationStack {
            ShareLifeGoalView(store: store)
        }
    }
}
