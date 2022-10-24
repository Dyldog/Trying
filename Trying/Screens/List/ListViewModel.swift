//
//  ListViewModel.swift
//  Trying
//
//  Created by Dylan Elliott on 24/10/2022.
//

import Foundation

class ViewModel: NSObject, ObservableObject {
    @Published var goals: [(goal: Goal, counts: [GoalCount])] = []
    @Published var detailViewModel: GoalDetailViewModel?
    @Published var addViewModel: AddGoalViewModel?
    private var manager: GoalsManager = .shared
    
    override init() {
        super.init()
        reload()
    }
    
    private func reload() {
        goals = manager.goals.map { ($0, manager.stats(for: $0)) }
    }
    
    func addTapped() {
        addViewModel = .init(goal: nil) { [weak self] in
            self?.manager.addGoal($0)
            self?.addViewModel = nil
            self?.reload()
        }
    }
    
    func goalTapped(_ goal: Goal) {
        detailViewModel = .init(goal: goal, onUpdate: { [weak self] in
            self?.reload()
            self?.detailViewModel = nil
        })
    }
}
