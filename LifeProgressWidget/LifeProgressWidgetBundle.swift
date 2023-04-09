//
//  LifeProgressWidgetBundle.swift
//  LifeProgressWidget
//
//  Created by Bartosz Król on 08/04/2023.
//

import WidgetKit
import SwiftUI

@main
struct LifeProgressWidgetBundle: WidgetBundle {
    var body: some Widget {
        LifeProgressWidget()
        YearProgressWidget()
    }
}
