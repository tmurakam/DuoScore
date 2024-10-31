//
//  PDFContentView.swift
//  DuoScore
//

import SwiftUI
import PDFKit

struct PDFContentView: View {
    @State private var pdfDocument: PDFDocument?
    @State private var showToolbar = true
    
    private let url: URL?
    
    var body: some View {
        NavigationStack {
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
            .toolbar {
                if showToolbar {
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
