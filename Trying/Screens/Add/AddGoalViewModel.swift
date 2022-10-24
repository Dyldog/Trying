//
//  AddGoalViewModel.swift
//  Trying
//
//  Created by Dylan Elliott on 24/10/2022.
//

import Foundation
import SwiftUI

class AddGoalViewModel: NSObject, ObservableObject, Identifiable {
    let id: UUID = .init()
    
    var title: String = ""
    
    @Published private var actions: [Action] = []
    
    private var onDone: (Goal) -> Void
    
    var existingID: UUID?
    
    init(goal: Goal?, onDone: @escaping (Goal) -> Void) {
        self.onDone = onDone
        
        self.existingID = goal?.id
        self.title = goal?.title ?? ""
        self.actions = goal?.actions ?? []
    }
    
    var actionIndices: [Int] { Array(0 ..< actions.count) }
    
    func actionTitle(for index: Int) -> String {
        actions[index].title
    }
    
    func actionBinding(for index: Int) -> Binding<String> {
        .init { [weak self] in
            self?.actionTitle(for: index) ?? ""
        } set: { [weak self] in
            self?.actions[index].title = $0
        }
        
    }
    
    func addTapped() {
        actions.append(.init(title: ""))
    }
    
    func deleteAction(at offsets: IndexSet) {
        actions.remove(atOffsets: offsets)
    }
    
    func doneTapped() {
        guard title.isEmpty == false else { return }
        
        onDone(.init(
            id: existingID ?? .init(),
            title: title,
            actions: actions
        ))
    }
}
