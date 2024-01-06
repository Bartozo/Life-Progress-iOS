//
//  OnboardingNotificationsView.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 03/05/2023.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingNotificationsView: View {
    
    @Environment(\.theme) var theme
    
    let store: StoreOf<OnboardingReducer>
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                Spacer()
                NotificationView()
                Spacer()
            }
            .aspectRatio(1, contentMode: .fit)
            .frame(maxWidth: .infinity)
            .edgesIgnoringSafeArea(.horizontal)
            .background(Color(.secondarySystemBackground))
            
            ScrollView {
                VStack(spacing: 24) {
                    Spacer()
                    Text("Notifications")
                        .font(.system(size: 32, weight: .bold))
                        .multilineTextAlignment(.center)
                    
                    Text("Allow notifications to never miss a key milestone in your life progress tracking.\n\n Stay informed about your life progress milestones, receive timely reminders, and get valuable insights that help you stay focused and achieve your goals more effectively.")
                           .font(.callout)
                           .multilineTextAlignment(.center)
                           .padding(.horizontal)
                }
                .padding()
            }
            .listStyle(.plain)
            
            Button {
                self.store.send(.allowNotificationsButtonTapped)
            } label: {
                Text("Allow notifications")
                    .font(.headline)
            }
            .tint(theme.color)
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    self.store.send(.skipNotificationsButtonTapped)
                } label: {
                    Text("Skip")
                }
                .tint(.secondary)
            }
        }
    }
}

private struct NotificationView: View {
    
    @Environment(\.theme) var theme
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "square.fill")
                .font(.largeTitle)
                .foregroundColor(theme.color)
            
            VStack(alignment: .leading) {
                Text("Lorem Ipsum")
                    .font(.headline)
                    .fontWeight(.bold)
                    
                Text("Lorem Ipsum Lorem Ipsum Lorem")
                    .font(.subheadline)
            }
            .redacted(reason: .placeholder)
        }
        .padding()
        .background(Color(.systemBackground).cornerRadius(16))
        .padding()
    }
}

// MARK: - Previews

#Preview {
    let store = Store(initialState: OnboardingReducer.State()) {
        OnboardingReducer()
    }
    
    return NavigationStack {
        OnboardingNotificationsView(store: store)
    }
}
