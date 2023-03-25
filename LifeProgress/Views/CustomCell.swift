//
//  CustomCell.swift
//  LifeProgress
//
//  Created by Bartosz Król on 25/03/2023.
//

import SwiftUI


struct CustomCell: View {
    
    private let title: String
    
    private let description: String
    
    private let systemImage: String?
    
    private let tint: Color
    
    private let action: (() -> Void)?
    
    
    init(
        title: String,
        description: String,
        systemImage: String? = nil,
        tint: Color = Color.blue,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.description = description
        self.systemImage = systemImage
        self.tint = tint
        self.action = action
    }
    
    var body: some View {
        if let action {
            Button(action: action) {
                content
            }
            .tint(.primary)
        } else {
            content
        }
    }
    
    var content: some View {
        HStack {
            if let systemImage {
                Image(systemName: systemImage)
                    .frame(maxWidth: 30)
                    .padding(.trailing, 10)
                    .foregroundColor(tint)
            }
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            if action != nil {
                NavigationLink.empty
                    .frame(maxWidth: 30)
            }
        }
    }
}

struct CustomCell_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CustomCell(title: "Title", description: "description", action: {})
            CustomCell(
                title: "Title",
                description: "description",
                systemImage: "calendar",
                action: {}
            )
            CustomCell(
                title: "Title",
                description: "description",
                systemImage: "person.3",
                action: {}
            )
        }
    }
}
