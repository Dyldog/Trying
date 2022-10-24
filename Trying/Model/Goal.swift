//
//  Goal.swift
//  Trying
//
//  Created by Dylan Elliott on 24/10/2022.
//

import Foundation

struct Goal: Codable, Identifiable {
    let id: UUID
    let title: String
    let actions: [Action]
}
