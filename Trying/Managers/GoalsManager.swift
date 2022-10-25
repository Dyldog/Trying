//
//  GoalsManager.swift
//  Trying
//
//  Created by Dylan Elliott on 24/10/2022.
//

import Foundation

extension Notification.Name {
    static var goalsUpdated: NSNotification.Name = .init(rawValue: "GOALS_UPDATED")
}

class GoalsManager {
    static var shared: GoalsManager = .init()
    
    private var fileManager: AppFileManager = .shared
    
    private(set) var goals: [Goal] = []
    
    private var completionDates: [Completion] = []
    
    
    init() {
        goals = fileManager.getFromFiles(.goals) ?? []
        completionDates = fileManager.getFromFiles(.completions) ?? []
    }
    
    private func addDummyData() {
        (0 ..< 100).forEach { (index: Int) in
            let date = Date.now.addingTimeInterval(TimeInterval(60 * 60 * 24 * index))
            goals.forEach { goal in
                goal.actions.forEach { action in
                    if let did = [true, false, nil].randomElement()! {
                        completionDates.append(.init(id: action.id, date: date, did: did))
                    }
                }
            }
        }
    }
    
    private func saveGoals() {
        fileManager.save(try! JSONEncoder().encode(goals), to: .goals)
        NotificationCenter.default.post(name: .goalsUpdated, object: nil)
    }
    
    private func saveCompletions() {
        fileManager.save(try! JSONEncoder().encode(completionDates), to: .completions)
        NotificationCenter.default.post(name: .goalsUpdated, object: nil)
    }
    
    func addGoal(_ goal: Goal) {
        goals.append(goal)
        saveGoals()
    }
    
    func updateGoal(_ goal: Goal) {
        goals = goals.filter { $0.id != goal.id } + [goal]
        saveGoals()
    }
    
    func markAction(_ action: Action, done: Bool) {
        let newCompletion: Completion = .init(id: action.id, date: .now, did: done)
        completionDates = completionDates.filter { !(action.id == $0.id && $0.date.isSameDay(as: .now)) } + [newCompletion]
        saveCompletions()
    }
    
    func completions(for goal: Goal) -> [ActionCompletion] {
        let todaysCompletions = completionDates
            .filter { $0.date.isSameDay(as: .now) }.reduce(into: [:]) { result, next in
                result[next.id] = next.did
            }
        
        return goal.actions.map {
            .init(action: $0, completed: todaysCompletions[$0.id])
        }
    }
    
    func delete(_ goal: Goal) {
        goals = goals.filter { $0.id != goal.id }
        
        let actionIDs = goal.actions.map { $0.id }
        completionDates = completionDates.filter { actionIDs.contains($0.id) == false }
        
        saveGoals()
        saveCompletions()
    }
    
    func stats(for goal: Goal) -> [GoalCount] {
        let dateFormetter = DateFormatter()
        dateFormetter.dateFormat = "yyyy-MM-dd"
        
        let completionDays = Dictionary(grouping: completionDates) {
            Calendar.autoupdatingCurrent.startOfDay(for: $0.date)
        }
        
        return completionDays.keys.sorted().map { date in
            let completions = completionDays[date] ?? []
            
            return GoalCount(date: date, bools: goal.actions.map { action in
                completions.first(where: { action.id == $0.id })?.did
            })
        }
    }
}

struct GoalCount {
    let date: Date
    let didCount: Int
    let didntCount: Int
    let missingCount: Int
    
    init(date: Date, bools: [Bool?]) {
        self.date = date
        self.didCount = bools.count(where: { $0 == true })
        self.didntCount = bools.count(where: { $0 == false })
        self.missingCount = bools.count(where: { $0 == nil })
    }
}

extension Date {
    func isSameDay(as other: Date) -> Bool {
        return Calendar.autoupdatingCurrent.isDate(self, inSameDayAs: other)
    }
}
