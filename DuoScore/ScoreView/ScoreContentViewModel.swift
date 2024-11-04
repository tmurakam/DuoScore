//
//  PDFContentViewModel.swift
//  DuoScore
//

import Foundation
import SwiftUI
import PDFKit

struct Command : Codable {
    let page: Int
}

class ScoreContentViewModel : ObservableObject {
    @Published var pdfDocument: PDFDocument?
    @Published var showToolbar = false
    
    private var url: URL?
    private var pdfViewContorller: PdfViewController?
    private let peerManager = PeerManager.shared
    
    init() {
        peerManager.viewModel = self
    }
    
    deinit {
        peerManager.viewModel = nil
    }
    
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
            //loadPdf(url: url)
        }
    }
    
    func onDisappear() {
        //peerManager.disconnect()
        peerManager.viewModel = nil
        pdfViewContorller?.viewModel = nil
    }
    
    func toggleToolBar() {
        showToolbar = !showToolbar
    }
    
    func loadPdf(url: URL) {
        let doc = PDFDocument(url: url)
        if doc == nil {
            print("Failed to load PDF: document: \(url)")
        } else {
            self.pdfDocument = doc
            pdfViewContorller?.setPdfDocument(doc: doc!)
        }
    }

    func onNextPage() {
        if peerManager.isSecondary() {
            return // TODO:
        }
        
        var cur = pdfViewContorller?.getCurrentPage() ?? -1
        if cur < 0 {
            return
        }
        let maxPage = (pdfDocument?.pageCount ?? 0) - 1
        let increment = peerManager.isPrimary() ? 2 : 1
        if cur + increment <= maxPage {
            cur += increment
            pdfViewContorller?.goToPage(page: cur)
            sendPageToPeer(page: cur + 1)
        }
    }
    
    func onPrevPage() {
        if peerManager.isSecondary() {
            return // TODO:
        }
        
        var cur = pdfViewContorller?.getCurrentPage() ?? -1
        let decrement = peerManager.isPrimary() ? 2 : 1
        if cur - decrement >= 0 {
            cur -= decrement
            pdfViewContorller?.goToPage(page: cur)
            sendPageToPeer(page: cur + 1)
        }
    }
    
    func sendPageToPeer(page: Int) {
        if peerManager.isConnected() {
            let cmd = Command(page: page)
            peerManager.sendCommand(cmd)
        }
    }
    
    func onCommand(_ command: Command) {
        pdfViewContorller?.goToPage(page: command.page)
    }
    
    /*
    func invite() {
        peerManager.invite()
    }
    
    func advertise() {
        peerManager.advertise()
    }
    */
}
