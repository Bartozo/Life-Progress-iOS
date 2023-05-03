//
//  SettingsCell.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 01/05/2023.
//

import SwiftUI

struct SettingsCell: View {
    
    @Environment(\.theme) var theme
    
    let title: String
    
    let systemImage: String
    
    let onTapped: (() -> Void)
    
    var body: some View {
        Button(action: onTapped) {
            HStack {
                Image(systemName: systemImage)
                    .frame(maxWidth: 30)
                    .padding(.trailing, 10)
                    .foregroundColor(theme.color)
                
                Text(title)
                
                Spacer()
                NavigationLink.empty
                    .frame(maxWidth: 30)
            }
        }
        .tint(.primary)
    }
}

// MARK: - Previews

struct SettingsCell_Previews: PreviewProvider {
    static var previews: some View {
        SettingsCell(title: "Share the app",systemImage: "square.and.arrow.up") {}
    }
}
