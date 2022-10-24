//
//  Action.swift
//  Trying
//
//  Created by Dylan Elliott on 24/10/2022.
//

import Foundation

struct Action: Codable, Identifiable {
    let id: UUID
    var title: String
    
    init(title: String) {
        self.id = .init()
        self.title = title
    }
}
