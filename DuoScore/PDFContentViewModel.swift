//
//  PDFContentViewModel.swift
//  DuoScore
//

import Foundation
import SwiftUI
import PDFKit

class PDFContentViewModel : ObservableObject {
    @Published var pdfDocument: PDFDocument?
    @Published var showToolbar = true
    
    private var url: URL?
    
    func setUrl(url: URL?) {
        self.url = url
    }
    
    func loadPDF() {
        if pdfDocument != nil { return }
        if let url = url {
            pdfDocument = PDFDocument(url: url)
        }
    }
}
