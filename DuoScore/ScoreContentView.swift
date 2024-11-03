//
//  PDFContentView.swift
//  DuoScore
//

import SwiftUI
import PDFKit

struct ScoreContentView: View {
    @StateObject private var viewModel = ScoreContentViewModel()
    
    let url: URL?
    
    var body: some View {
        NavigationStack {
            VStack {
                if let pdfDocument = viewModel.pdfDocument {
                    PdfViewWrapper(pdfContentViewModel: viewModel)
                        .edgesIgnoringSafeArea(.all)
                } else {
                    Text("Loading PDF...")
                }
            }
            .onAppear {
                viewModel.setUrl(url: url)
                viewModel.loadPDF()
            }
            .toolbar {
                if viewModel.showToolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            viewModel.openFile()
                        }) {
                            Image(systemName: "folder")
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu(content: {
                            Button(action: {
                                viewModel.invite()
                            }) {
                                Text("Invite")
                            }
                            Button(action: {
                                viewModel.advertise()
                            }) {
                                Text("Advertise")
                            }
                        }) {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
            }
        }
    }
    
    init (url: URL?) {
        self.url = url
        //viewModel.setUrl(url: url)
        //viewModel.loadPDF()
    }
}

#Preview {
    ScoreContentView(url: nil)
}
