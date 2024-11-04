//
//  FileView.swift
//  DuoScore
//

import SwiftUI

struct FileView: View {
    @StateObject private var viewModel = FileViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.scores) {
                Text($0.name)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        //viewModel.openFile()
                        print("file")
                    }) {
                        Image(systemName: "folder")
                    }
                }
            }
        }
    }
}

#Preview {
    FileView()
}
