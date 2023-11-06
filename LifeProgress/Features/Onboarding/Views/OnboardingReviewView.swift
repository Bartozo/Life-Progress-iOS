//
//  OnboardingReviewView.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 06/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingReviewView: View {
    
    @Environment(\.theme) var theme
    
    @Environment(\.requestReview) var requestReview
    
    let store: StoreOf<OnboardingReducer>
    
    var body: some View {
        VStack {
            List {
                Section {
                    VStack(spacing: 24) {
                        HStack {
                            Spacer()
                            Image(systemName: "star.fill")
                                .font(.system(size: 72))
                                .foregroundColor(theme.color)
                            Spacer()
                        }
                        
                        Text("Help me growth")
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(.top, 10)
                    }
                    .padding()
                }
                .listRowBackground(Color.clear)
                
                Section {
                    VStack(alignment: .leading) {
                        Text("👋 Hello ")
                            .font(.headline)
                            .fontWeight(.bold)
                    
                        Text("I am the solo developer behind this app. Your feedback means the world to me. Would you mind leaving a review to support my work?")
                            .font(.subheadline)
                    }
                    Button {
                       requestReview()
                    } label: {
                        Text("Leave a Review")
                    }
                    .tint(theme.color)
                }
            }
            
            Button {
                self.store.send(.continueButtonTapped)
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
    let store = Store(initialState: OnboardingReducer.State()) {
        OnboardingReducer()
    }
    
    return OnboardingReviewView(store: store)
}
