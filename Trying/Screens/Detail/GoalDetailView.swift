//
//  GoalDetailView.swift
//  Trying
//
//  Created by Dylan Elliott on 24/10/2022.
//

import SwiftUI

struct GoalDetailView: View {
    @StateObject var viewModel: GoalDetailViewModel
    @State var showActionSheet: Bool = false
    
    private func color(for completed: Bool?) -> Color {
        switch completed {
        case nil: return .white
        case .some(false): return .red
        case .some(true): return .green
        }
    }
    
    private func textColor(for completed: Bool?) -> Color {
        switch completed {
        case nil: return .black
        case .some: return .white
        }
    }
    
    var body: some View {
        GeometryReader { proxy in
            List {
                ZStack {
                    Text(viewModel.goal.title)
                        .fontWeight(.semibold)
                        .padding(20)
                        .font(.largeTitle)
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            showActionSheet = true
                        } label: {
                            Image(systemName: "ellipsis")
                        }
                    }
                }
                
                ForEach(viewModel.completions) { completion in
                    SwipeView(width: proxy.size.width) {
                        Text(completion.action.title)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(20)
                            .background(color(for: completion.completed))
                            .foregroundColor(textColor(for: completion.completed))
                            .font(.largeTitle)
                    } onLeftSwipe: {
                        viewModel.markAsNotDone(completion)
                    } onRightSwipe: {
                        viewModel.markAsDone(completion)
                    }
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .popover(item: $viewModel.editViewModel) { viewModel in
            AddGoalView(viewModel: viewModel)
        }
        .confirmationDialog(
            "Edit",
            isPresented: $showActionSheet) {
                Button("Edit") {
                    viewModel.editTapped()
                }
                
                Button("Delete") {
                    viewModel.deleteTapped()
                }
            }
    }
}
