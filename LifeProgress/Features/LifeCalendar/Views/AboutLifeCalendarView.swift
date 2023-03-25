//
//  AboutLifeCalendarView.swift
//  LifeProgress
//
//  Created by Bartosz Król on 25/03/2023.
//

import SwiftUI
import ComposableArchitecture

struct AboutLifeCalendarView: View {
    
    @Environment(\.openURL) var openURL
    
    @Environment(\.theme) var theme
    
    let store: LifeCalendarStore
    
    var body: some View {
        NavigationStack {
            Form {
                HowItWorksSection(store: self.store)
                LearnMoreSection(openUrl: { url in
                    openURL(URL(string: url)!)
                })
                SupportSection(openUrl: { url in
                    openURL(URL(string: url)!)
                })
            }
            .navigationTitle("About Life Progress")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {

                    }) {
                        Text("Close")
                    }
                }
            }
        }
        .tint(theme.color)
    }
}

private struct HowItWorksSection: View {
    
    @Environment(\.theme) var theme
    
    let store: LifeCalendarStore
    
    var body: some View {
        Section("How it works") {
            VStack {
                CustomCell(
                    title: "A calendar for your life",
                    description: "Each square you see on screen represents a week in your life. The first square (the one at the top left) is the week you were born.",
                    systemImage: "calendar",
                    tint: theme.color
                )
                
                WithViewStore(self.store, observe: \.life) { viewStore in
                    let life = viewStore.state
                    
                    ZStack(alignment: .topLeading) {
                        SimplifiedLifeCalendarView(life: life)
                            .frame(width: 150, height: 200)
                            .padding(.leading, 100)
                            .padding(.top, 100)

                        ZoomedInCalendarView()
                    }

                }
            }
            
            VStack {
                CustomCell(
                    title: "Each color represents different stage in your life",
                    description: "Each color highlights a distinct life stage, offering a concise, visual overview of age-related milestones.",
                    systemImage: "calendar",
                    tint: theme.color
                )
                
                AgeGroupGridView()
                    .padding()
            }
            
            VStack {
                CustomCell(
                    title: "Each row of 52 weeks makes up one year",
                    description: "This is what your current year looks like, see if you can spot it on the calendar.",
                    systemImage: "square.on.square",
                    tint: theme.color
                )
                
                WithViewStore(self.store, observe: \.life) { viewStore in
                    let life = viewStore.state
                    
                    CurrentYearProgressView(life: life)
                        .padding()
                }
            }

            CustomCell(
                title: "Last thing!",
                description: "Try tapping on the calendar and see what happens.",
                systemImage: "exclamationmark.triangle",
                tint: theme.color
            )
        }
    }
}

private struct LearnMoreSection: View {
    
    @Environment(\.theme) var theme
    
    private let openUrl: (String) -> Void
    
    init(openUrl: @escaping (String) -> Void) {
        self.openUrl = openUrl
    }
    
    var body: some View {
        Section("Learn more") {
            CustomCell(
                title: "Your Life in Weeks",
                description: "This idea was originally introduced in an article by Tim Urban.",
                systemImage: "calendar",
                tint: theme.color,
                action: {
                    openUrl("https://waitbutwhy.com/2014/05/life-weeks.html")
                }
            )
            
            CustomCell(
                title: "What Are You Doing With Your Life? The Tail End",
                description: "Kurzgesagt's phenomenal video on the topic.",
                systemImage: "video",
                tint: theme.color,
                action: {
                    openUrl("https://www.youtube.com/watch?v=JXeJANDKwDc")
                }
            )

            CustomCell(
                title: "The project is open source!",
                description: "Learn how this project was created and contribute to it. Check out the code on GitHub.",
                systemImage: "person.3",
                tint: theme.color,
                action: {
                    openUrl("https://github.com/Bartozo/Life-Progress-iOS")
                }
            )
        }
    }
}

private struct SupportSection: View {
    
    @Environment(\.theme) var theme
    
    private let openUrl: (String) -> Void
    
    init(openUrl: @escaping (String) -> Void) {
        self.openUrl = openUrl
    }
    
    var body: some View {
        Section("Support") {
            CustomCell(
                title: "Support this project",
                description: "If you enjoy using this application and want it to has more features, you can support the development of this project by buying me a coffee.",
                systemImage: "cup.and.saucer",
                tint: theme.color,
                action: {
                    openUrl("https://www.buymeacoffee.com/bartozo")
                }
            )
        }
    }
}

struct AgeGroupGridView: View {
    
    // MARK: - Properties
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    // MARK: - Body
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(AgeGroup.allCases, id: \.self) { ageGroup in
                VStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(ageGroup.color)
                        .frame(width: 16, height: 16)
                    Text(ageGroup.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

                
//
//struct AboutLifeCalendarView_Previews: PreviewProvider {
//    static var previews: some View {
//        AboutLifeCalendarView()
//    }
//}
