//
//  CreditCell.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 01/08/2023.
//

import SwiftUI

struct CreditCell: View {
    
    @Environment(\.theme) var theme
    
    let title: String
    
    let onTapped: (() -> Void)
    
    var body: some View {
        Button(action: onTapped) {
            HStack {
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

#Preview {
    CreditCell(title: "Package XYZ") {}
}
