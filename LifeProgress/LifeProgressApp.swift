//
//  LifeProgressApp.swift
//  LifeProgress
//
//  Created by Bartosz Król on 08/03/2023.
//

import SwiftUI

@main
struct LifeProgressApp: App {
//    let persistenceController = PersistenceController.shared
    
    let store = RootStore(
        initialState: RootReducer.State(),
        reducer: RootReducer()
    )

    var body: some Scene {
        WindowGroup {
//            MyTestView()
            RootView(store: self.store)
                .modifier(
                    ThemeApplicator(
                        store: self.store.scope(state: \.profile.theme).actionless
                    )
                )
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}


struct MyTestView: View {
    
    @StateObject private var icloudStorage = iCloudStorage()
    @State private var inputValue: String = ""
    

    var body: some View {
        VStack {
            TextField("Enter a value", text: $inputValue)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Save to iCloud") {
                icloudStorage.saveValueToiCloud(inputValue)
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(8)
            
            Button("Load from iCloud") {
                icloudStorage.loadValueFromiCloud()
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.green)
            .cornerRadius(8)
            
            Text("Retrieved value: \(icloudStorage.storedValue)")
                .padding()
        }
        .padding()
    }
}

struct MyTestView_Previews: PreviewProvider {
    static var previews: some View {
        MyTestView()
    }
}


import Foundation
import Combine

class iCloudStorage: ObservableObject {
    @Published var storedValue: String = ""
    private let keyValueStore = NSUbiquitousKeyValueStore.default
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadValueFromiCloud()
        observeiCloudChanges()
    }
    
    func loadValueFromiCloud() {
        if let value = keyValueStore.string(forKey: "myKey") {
            storedValue = value
        }
    }
    
    func saveValueToiCloud(_ value: String) {
        keyValueStore.set(value, forKey: "myKey")
        keyValueStore.synchronize()
    }
    
    private func observeiCloudChanges() {
        NotificationCenter.default.publisher(for: NSUbiquitousKeyValueStore.didChangeExternallyNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notification in
                print("✅ New data in the store")
                self?.loadValueFromiCloud()
            }
            .store(in: &cancellables)
    }
}
