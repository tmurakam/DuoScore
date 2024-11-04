//
//  FileView.swift
//  DuoScore
//

import SwiftUI

struct FileView: View {
    @StateObject private var viewModel = FileViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.scores) { item in
                Button(
                    action: {
                        viewModel.onSelect(score: item)
                    }, label: {
                        Text(item.name)
                    }
                )
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        viewModel.chooseFileToImport()
                    }) {
                        Image(systemName: "square.and.arrow.down")
                    }
                }
            }
        }
    }
}

#Preview {
    FileView()
}
