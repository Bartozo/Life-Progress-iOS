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
    
    let store: OnboardingStore
    
    var body: some View {
        WithViewStore(self.store.stateless) { viewStore in
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
                    viewStore.send(.startJourneyButtonTapped)
                } label: {
                    Text("Start Your Journey")
                        .font(.headline)
                }
                .tint(theme.color)
                .padding()
            }
        }
    }
}


// MARK: - Previews
struct OnboardingCompletedView_Previews: PreviewProvider {
    
    static var previews: some View {
        let store = Store<OnboardingReducer.State, OnboardingReducer.Action>(
            initialState: OnboardingReducer.State(),
            reducer: OnboardingReducer()
        )
        OnboardingCompletedView(store: store)
    }
}
