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
        
        pdfView.window?.rootViewController = KeyTestController(rootView: self)
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
        //
    }
}

class KeyTestController: UIHostingController<PDFKitView> {
    required override init(rootView: PDFKitView) {
        super.init(rootView: rootView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


#Preview {
    PdfContentView()
}
