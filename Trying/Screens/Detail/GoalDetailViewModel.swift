//
//  GoalDetailViewModel.swift
//  Trying
//
//  Created by Dylan Elliott on 24/10/2022.
//

import Foundation

struct ActionCompletion: Identifiable {
    var id: UUID { action.id }
    let action: Action
    var completed: Bool?
}

class GoalDetailViewModel: NSObject, ObservableObject, Identifiable {
    let id: UUID = .init()
    var goal: Goal
    let manager: GoalsManager = .shared
    @Published var completions: [ActionCompletion] = []
    let onUpdate: () -> Void
    @Published var editViewModel: AddGoalViewModel?
    
    init(goal: Goal, onUpdate: @escaping () -> Void) {
        self.goal = goal
        self.onUpdate = onUpdate
        super.init()
        self.reload()
    }
    
    private func reload() {
        self.completions = manager.completions(for: goal)
    }
    
    private func mark(completion: ActionCompletion, done: Bool) {
        manager.markAction(completion.action, done: done)
        reload()
    }
    
    func markAsDone(_ completion: ActionCompletion) {
        mark(completion: completion, done: true)
    }
    
    func markAsNotDone(_ completion: ActionCompletion) {
        mark(completion: completion, done: false)
    }
    
    func deleteTapped() {
        manager.delete(goal)
        onUpdate()
    }
    
    func editTapped() {
        editViewModel = .init(goal: goal, onDone: { [weak self] updated in
            self?.goal = updated
            self?.reload()
            self?.manager.updateGoal(updated)
            self?.editViewModel = nil
        })
    }
}
