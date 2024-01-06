//
//  OnboardingCompletedView.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 04/05/2023.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingCompletedView: View {
    
    @Environment(\.theme) var theme
    
    let store: StoreOf<OnboardingReducer>
    
    var body: some View {
        VStack {
            List {
                HStack {
                    Spacer()
                    Text("That's all, enjoy your life!")
                        .font(.largeTitle.weight(.bold))
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                .listRowBackground(Color.clear)
                
                Section {
                    Text("Now you're ready to make the most of your life journey with this app by your side.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
            }
            
            Button {
                self.store.send(.startJourneyButtonTapped)
            } label: {
                Text("Start Your Journey")
                    .font(.headline)
            }
            .tint(theme.color)
            .padding()
        }
    }
}


// MARK: - Previews

#Preview {
    let store = Store(initialState: OnboardingReducer.State()) {
        OnboardingReducer()
    }
    
    return OnboardingCompletedView(store: store)
}
