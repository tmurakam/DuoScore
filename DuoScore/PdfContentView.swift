//
//  ContentView.swift
//  DuoScore
//

import SwiftUI
import PDFKit

struct PdfContentView: View {
    var body: some View {
        PDFKitView(urlString: "ballade4")
    }
}

struct PDFKitView: UIViewRepresentable {
    private let url: URL
    private let pdfView: PDFView
    
    init(urlString: String) {
        self.url = Bundle.main.url(forResource: urlString, withExtension: "pdf")!
        self.pdfView = PDFView()
    }
    
    func makeUIView(context: Context) -> PDFView {
        pdfView.document = PDFDocument(url: url)
        pdfView.autoScales = true
        pdfView.displayMode = .singlePage
        pdfView.backgroundColor = .clear
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
        //
    }
}


#Preview {
    PdfContentView()
}
