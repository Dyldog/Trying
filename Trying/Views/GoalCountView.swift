//
//  GoalCountView.swift
//  Trying
//
//  Created by Dylan Elliott on 24/10/2022.
//

import SwiftUI

struct GoalCountView: View {
    let counts: [GoalCount]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(counts.sorted(by: { $0.date < $1.date }), id: \.date) { count in
                VStack(spacing: 0) {
                    ForEach(0 ..< count.missingCount) { _ in
                        Rectangle().foregroundColor(.white)
                    }
                    
                    ForEach(0 ..< count.didntCount) { _ in
                        Rectangle().foregroundColor(.red)
                    }
                    
                    ForEach(0 ..< count.didCount) { _ in
                        Rectangle().foregroundColor(.green)
                    }
                }
            }
        }
        .background(Color.blue)
    }
}

