//
//  PDFContentViewModel.swift
//  DuoScore
//

import Foundation
import SwiftUI
import PDFKit

class ScoreContentViewModel : ObservableObject {
    @Published var pdfDocument: PDFDocument?
    @Published var showToolbar = true
    
    private var url: URL?
    private var pdfViewContorller: PdfViewController?
    
    func setUrl(url: URL?) {
        self.url = url
    }
    
    func setPdfViewController(pdfViewController: PdfViewController) {
        pdfViewContorller = pdfViewController
    }
    
    func loadPDF() {
        if pdfDocument != nil { return }
        if let url = url {
            pdfDocument = PDFDocument(url: url)
        }
    }
    
    func toggleToolBar() {
        showToolbar = !showToolbar
    }
    
    func openFile() {
        pdfViewContorller?.openFile()
    }
}
