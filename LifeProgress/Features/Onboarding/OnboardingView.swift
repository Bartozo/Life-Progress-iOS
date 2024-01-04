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
    
    let store: StoreOf<OnboardingReducer>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack(
                path: viewStore.$path
            ) {
                VStack {
                    Spacer()
                    Text("Welcome to Life Progress")
                        .font(.largeTitle.weight(.semibold))
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                    
                    Spacer()
                    
                    Button {
                        viewStore.send(.getStartedButtonTapped)
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
                        OnboardingAboutView(store: self.store)
                        
                    case .birthday:
                        OnboardingBirthdayView(store: self.store)
                        
                    case .lifeExpectancy:
                        OnboardingLifeExpectancyView(store: self.store)
                        
                    case .notifications:
                        OnboardingNotificationsView(store: self.store)
                        
                    case .review:
                        OnboardingReviewView(store: self.store)
                        
                    case .completed:
                        OnboardingCompletedView(store: self.store)
                    }
                }
            }
            .tint(theme.color)
        }
    }
}

// MARK: - Previews

#Preview {
    let store = Store(initialState: OnboardingReducer.State()) {
        OnboardingReducer()
    }
    
    return OnboardingView(store: store)
}

