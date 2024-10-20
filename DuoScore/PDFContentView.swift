//
//  PDFContentView.swift
//  DuoScore
//

import SwiftUI
import PDFKit

struct PDFContentView: View {
    @State private var pdfDocument: PDFDocument?
    private let url: URL?
    
    var body: some View {
        VStack {
            if let pdfDocument = pdfDocument {
                PDFViewWrapper(pdfDocument: pdfDocument)
                    .edgesIgnoringSafeArea(.all)
            } else {
                Text("Loading PDF...")
            }
        }
        .onAppear {
            loadPDF()
        }
    }
    
    init (url: URL?) {
        self.url = url
    }
    
    private func loadPDF() {
        if pdfDocument != nil { return }
        if let url = url {
            pdfDocument = PDFDocument(url: url)
        }
    }
}

#Preview {
    PDFContentView(url: nil)
}
