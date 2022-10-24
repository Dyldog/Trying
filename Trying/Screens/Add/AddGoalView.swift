//
//  AddGoalView.swift
//  Trying
//
//  Created by Dylan Elliott on 24/10/2022.
//

import SwiftUI

struct AddGoalView: View {
    @StateObject var viewModel: AddGoalViewModel
    
    var body: some View {
        VStack {
            List {
                Section {
                    TextField("Title", text: $viewModel.title)
                        .multilineTextAlignment(.center)
                        .font(.largeTitle)
                }
                
                
                Section {
                    ForEach(viewModel.actionIndices) {
                        TextField(
                            viewModel.actionTitle(for: $0),
                            text: viewModel.actionBinding(for: $0),
                            prompt: Text("Enter action title...")
                        )
                        .font(.largeTitle)
                    }
                    .onDelete(perform: viewModel.deleteAction)
                    
                    Button("Add Action") {
                        viewModel.addTapped()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.largeTitle)
                }
                
                Section {
                    Button("Save") {
                        viewModel.doneTapped()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.largeTitle)
                }
            }
        }
        .navigationTitle("Add Goal")
    }
}

extension Int: Identifiable {
    public var id: Int { self }
}
