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
    
    func setUrl(url: URL?) {
        self.url = url
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
        
    }
}
