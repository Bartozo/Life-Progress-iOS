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
    
    let store: StoreOf<ShareLifeGoalReducer>
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ImagePreview(store: store)
                        .environment(\.colorScheme, store.theme == .dark ? .dark : .light)
                }
                .listRowInsets(EdgeInsets())
                
                Section {
                    ThemePicker(store: store)
                    ColorPickerView(
                        store: store.scope(
                            state: \.colorPicker,
                            action: \.colorPicker
                        )
                    )
                    TimeSwitch(store: store)
                    WatermarkSwitch(store: store)
                }
            }
            .navigationTitle("Share Life Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        store.send(.closeButtonTapped)
                    } label: {
                        Text("Close")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    ShareLink(
                        item: Image(
                            uiImage: generateSnapshot(
                                theme: store.theme,
                                color: store.colorPicker.color.colorValue,
                                isTimeVisible: store.isTimeVisible,
                                isWatermarkVisible: store.isWatermarkVisible
                            )
                        ),
                        preview: SharePreview(
                            "Life Goal",
                            image: Image(
                                uiImage: generateSnapshot(
                                    theme: store.theme,
                                    color: store.colorPicker.color.colorValue,
                                    isTimeVisible: store.isTimeVisible,
                                    isWatermarkVisible: store.isWatermarkVisible
                                )
                            )
                        )
                    )
                }
            }
        }
        .tint(theme.color)
    }
    
    @MainActor
    private func generateSnapshot(
        theme: ShareLifeGoalReducer.State.Theme,
        color: Color,
        isTimeVisible: Bool,
        isWatermarkVisible: Bool
    ) -> UIImage {
        let screenSize = UIScreen.main.bounds.size
        let imagePreview = ImagePreview(store: store)
            .frame(width: screenSize.width, height: screenSize.width)
            .environment(\.colorScheme, theme == .dark ? .dark : .light)
            .environment(\.locale, Locale.current)
        let renderer = ImageRenderer(content: imagePreview)
        renderer.scale = UIScreen.main.scale
     
        return renderer.uiImage ?? UIImage()
    }
}

private struct ImagePreview: View {
    
    let store: StoreOf<ShareLifeGoalReducer>

    var body: some View {
        ZStack {
            ColorGradientBackground(store: store.scope(state: \.colorPicker, action: \.colorPicker))
            
            VStack {
                Image(systemName: store.lifeGoal.symbolName)
                    .padding()
                    .background(in: Circle())
                    .foregroundStyle(.white.shadow(.drop(radius: 1, x: 2, y: 2)))
                    .backgroundStyle(store.colorPicker.color.colorValue.gradient)
                    .font(.system(size: 60))
                    .padding(.bottom)
                
                VStack(alignment: .center) {
                    Text(store.lifeGoal.title)
                        .lineLimit(2)
                        .font(.headline)
                    
                    Text(store.lifeGoal.details)
                        .lineLimit(3)
                        .font(.footnote)
                        .padding(.horizontal)
                    
                    if store.isTimeVisible {
                        Text(store.lifeGoal.finishedAt!, style: .date)
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
                 if store.isWatermarkVisible {
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

private struct ThemePicker: View {
    
    @Bindable var store: StoreOf<ShareLifeGoalReducer>
    
    var body: some View {
        Picker(
            "Theme",
            selection: $store.theme.animation()
        ) {
            ForEach(ShareLifeGoalReducer.State.Theme.allCases, id: \.self) { theme in
                Text(theme.title)
                    .tag(theme)
            }
        }
        .pickerStyle(.segmented)
    }
}

private struct TimeSwitch: View {
    
    @Bindable var store: StoreOf<ShareLifeGoalReducer>
    
    var body: some View {
        Toggle(
            "Show time",
            isOn: $store.isTimeVisible.animation()
        )
    }
}

private struct WatermarkSwitch: View {
    
    @Bindable var store: StoreOf<ShareLifeGoalReducer>
    
    var body: some View {
        Toggle(
            "Show watermark",
            isOn: $store.isWatermarkVisible.animation()
        )
    }
}

// MARK: - Previews

#Preview {
    NavigationStack {
        ShareLifeGoalView(
            store: Store(
                initialState: ShareLifeGoalReducer.State(
                    lifeGoal: LifeGoal(
                        id: UUID(),
                        title: "Road Trip on Route 66",
                        finishedAt: Date.now,
                        symbolName: "trophy",
                        details: "Plan and embark on a memorable road trip across America's historic Route 66"
                    )
                )
            ) {
                ShareLifeGoalReducer()
            }
        )
    }
}
