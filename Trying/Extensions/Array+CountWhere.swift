//
//  Array+CountWhere.swift
//  Trying
//
//  Created by Dylan Elliott on 24/10/2022.
//

import Foundation

extension Array {
    func count(where checker: (Element) -> Bool) -> Int {
        filter { checker($0) }.count
    }
}
