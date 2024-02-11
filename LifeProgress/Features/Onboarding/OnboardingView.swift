//
//  OnboardingView.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 03/05/2023.
//

import SwiftUI
import ComposableArchitecture
import ConfettiSwiftUI

struct OnboardingView: View {
    @Environment(\.theme) var theme
    
    @Bindable var store: StoreOf<OnboardingReducer>
    
    var body: some View {
        NavigationStack(path: $store.path) {
            VStack {
                Spacer()
                Text("Welcome to Life Progress")
                    .font(.largeTitle.weight(.semibold))
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                
                Spacer()
                
                Button {
                    store.send(.getStartedButtonTapped)
                } label: {
                    Text("Get Started")
                        .font(.headline)
                }
                .tint(theme.color)
            }
            .padding()
            .navigationDestination(for: OnboardingReducer.State.Screen.self) { screen in
                switch screen {
                case .about:
                    OnboardingAboutView(store: store)
                    
                case .birthday:
                    OnboardingBirthdayView(store: store)
                    
                case .lifeExpectancy:
                    OnboardingLifeExpectancyView(store: store)
                    
                case .notifications:
                    OnboardingNotificationsView(store: store)
                    
                case .review:
                    OnboardingReviewView(store: store)
                    
                case .completed:
                    OnboardingCompletedView(store: store)
                }
            }
        }
        .tint(theme.color)
    }
}

// MARK: - Previews

#Preview {
    OnboardingView(
        store: Store(initialState: OnboardingReducer.State()) {
            OnboardingReducer()
        }
    )
}

