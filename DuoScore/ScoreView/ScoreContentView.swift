//
//  PDFContentView.swift
//  DuoScore
//

import SwiftUI
import PDFKit

struct ScoreContentView: View {
    @StateObject var viewModel = ScoreContentViewModel()
    
    let url: URL?
    
    var body: some View {
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
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear() {
            viewModel.onDisappear()
            UIApplication.shared.isIdleTimerDisabled = false
        }
        .navigationBarHidden(!viewModel.showToolbar)
    }
    
    init (url: URL?) {
        self.url = url
    }
}

#Preview {
    ScoreContentView(url: nil)
}
