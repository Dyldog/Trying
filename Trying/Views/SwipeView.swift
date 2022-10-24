//
//  SwipeView.swift
//  Trying
//
//  Created by Dylan Elliott on 24/10/2022.
//

import SwiftUI

struct SwipeView<Content: View>: View {
    let width: CGFloat
    let content: () -> Content
    let onLeftSwipe: () -> Void
    let onRightSwipe: () -> Void
    @State private var offset: CGFloat = 0
    @State private var dragTriggered: Bool = false
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                Rectangle().foregroundColor(.green)
                Rectangle().foregroundColor(.red)
            }
            .background(Color.blue)
            .padding(0)
            .frame(maxHeight: .infinity)
            
            
            content()
                .padding(.vertical, 0)
                .frame(maxWidth: .infinity)
                .offset(x: offset, y: 0)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            guard dragTriggered == false else { return }
                            if abs(gesture.translation.width) >= width / 2 {
                                
                                dragTriggered = true
                                
                                if gesture.translation.width < 0 {
                                    onLeftSwipe()
                                } else {
                                    onRightSwipe()
                                }
                                
                                offset = 0
                            } else {
                                offset = gesture.translation.width
                            }
                        }
                        .onEnded { _ in
                            dragTriggered = false
                            offset = 0
                        }
                )
            
        }
    }
}
