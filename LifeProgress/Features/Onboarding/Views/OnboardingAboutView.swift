//
//  OnboardingAboutView.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 04/05/2023.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingAboutView: View {
    @Environment(\.theme) var theme
    
    let store: StoreOf<OnboardingReducer>
    
    var body: some View {
        VStack {
            List {
                HStack {
                    Spacer()
                    Text("Introducing Life Progress")
                        .font(.largeTitle.weight(.bold))
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                .listRowBackground(Color.clear)
                
                Section {
                    ForEach(About.getAbouts(), id: \.self) { feature in
                        HStack {
                            Image(systemName: feature.symbolName)
                                .foregroundColor(theme.color)
                                .font(.title.weight(.regular))
                                .frame(width: 60, height: 50)
                                .clipped()
                            
                            VStack(alignment: .leading, spacing: 3) {
                                Text(feature.title)
                                    .font(.footnote.weight(.semibold))
                                Text(feature.description)
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            
            Button {
                store.send(.continueButtonTapped)
            } label: {
                Text("Continue")
                    .font(.headline)
            }
            .tint(theme.color)
            .padding()
        }
    }
}


// MARK: - Previews

#Preview {
    OnboardingAboutView(
        store: Store(initialState: OnboardingReducer.State()) {
            OnboardingReducer()
        }
    )
}
