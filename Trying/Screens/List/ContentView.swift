//
//  ContentView.swift
//  Trying
//
//  Created by Dylan Elliott on 24/10/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: ViewModel = .init()
    
    var body: some View {
        ZStack {
            VStack {
                Text("YOU ARE TRYING")
                    .fontWeight(.semibold)
                    .padding(20)
                    .font(.largeTitle)
                
                Spacer()
                
                ForEach(Array(viewModel.goals.enumerated()), id: \.offset) { (offset, goal) in
                    Button {
                        viewModel.goalTapped(goal.goal)
                    } label: {
                        VStack(spacing: 0) {
                            Text("\(offset + 1). \(goal.goal.title)")
                                .fontWeight(.semibold)
                                .padding([.horizontal, .top], 20)
                                .font(.largeTitle)
                            GoalCountView(counts: goal.counts)
                                .frame(height: 20)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                
                Spacer()
                Spacer()
                
                VStack(spacing: 5) {
                    Text("KEEP TRYING")
                        .fontWeight(.semibold)
                        .padding([.horizontal, .top], 20)
                        .font(.largeTitle)
                    
                    if viewModel.goals.count < 3 {
                        Button {
                            viewModel.addTapped()
                        } label: {
                            Text("Add Goal")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .popover(item: $viewModel.addViewModel, content: { viewModel in
            NavigationView {
                AddGoalView(viewModel: viewModel)
            }
        })
        .popover(item: $viewModel.detailViewModel, content: { viewModel in
            NavigationView {
                GoalDetailView(viewModel: viewModel)
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
