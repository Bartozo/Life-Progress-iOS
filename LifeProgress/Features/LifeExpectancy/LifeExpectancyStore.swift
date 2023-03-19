//
//  LifeExpectancyStore.swift
//  LifeProgress
//
//  Created by Bartosz Król on 13/03/2023.
//


import Foundation
import ComposableArchitecture

/// A type alias for a store of the `LifeExpectancyReducer`'s state and action types.
typealias LifeExpectancyStore = Store<LifeExpectancyReducer.State, LifeExpectancyReducer.Action>

/// A reducer that manages the state of the life expectancy.
struct LifeExpectancyReducer: ReducerProtocol {
    
    @Dependency(\.userClient) var userClient: UserClient
    
    /// The state of the birthday.
    struct State: Equatable {
        /// The user's life expectancy.
        var lifeExpectancy: Int = UserDefaultsHelper.getLifeExpectancy()
        
        /// Whether the slider is visible.
        var isSliderVisible = false
    }
    
    /// The actions that can be taken on the life expectancy.
    enum Action: Equatable {
        /// Indicates that the life expectancy value has changed.
        case lifeExpectancyChanged(Double)
        /// Indicates that the slider visible status has changed.
        case isSliderVisibleChanged
        /// Indicates that the view has appeared.
        case onAppear
    }
    
    /// The body of the reducer that processes incoming actions and updates the state accordingly.
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .lifeExpectancyChanged(let lifeExpectancy):
                state.lifeExpectancy = Int(lifeExpectancy)
                UserDefaultsHelper.saveLifeExpectancy(Int(lifeExpectancy))
                return .none
                
            case .isSliderVisibleChanged:
                state.isSliderVisible.toggle()
                return .none
                
            case .onAppear:
                state.lifeExpectancy = UserDefaultsHelper.getLifeExpectancy()
                return .none
            }
        }
    }

}

