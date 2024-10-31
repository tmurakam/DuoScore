//
//  PDFContentView.swift
//  DuoScore
//

import SwiftUI
import PDFKit

struct PDFContentView: View {
    @StateObject private var viewModel = PDFContentViewModel()
    
    let url: URL?
    
    var body: some View {
        NavigationStack {
            VStack {
                if let pdfDocument = viewModel.pdfDocument {
                    PDFViewWrapper(pdfContentViewModel: viewModel)
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
                        Button {
                        } label: {
                            Text("Test")
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
    PDFContentView(url: nil)
}
