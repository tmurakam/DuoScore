//
//  PDFContentView.swift
//  DuoScore
//

import SwiftUI
import PDFKit

struct PDFContentView: View {
    @State private var pdfDocument: PDFDocument?

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
    
    private func loadPDF() {
        let url = Bundle.main.url(forResource: "ballade4", withExtension: "pdf")!
        pdfDocument = PDFDocument(url: url)
    }
}


#Preview {
    PDFContentView()
}
