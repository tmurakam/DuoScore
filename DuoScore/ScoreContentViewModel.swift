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
    private let peerManager = PeerManager()
    
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

    func openFile() {
        //pdfViewContorller?.openFile()
        let picker = DocumentPicker { urls in
            if let url = urls.first {
                if url.startAccessingSecurityScopedResource() {
                    defer { url.stopAccessingSecurityScopedResource() }
                    do {
                        let isReachable = try url.checkResourceIsReachable()
                        if !isReachable {
                            print("Attempt to download from iCloud")
                            try FileManager.default.startDownloadingUbiquitousItem(at: url)
                            self.observeFiledownload(url: url)
                        } else {
                            self.loadPdf(url: url)
                        }
                    } catch {
                        print("Error: \(error)")
                    }
                } else {
                    print("startAccessingSecurityScopedResource() failed")
                }
            }
        }
        
        let hostingController = UIHostingController(rootView: picker)
        pdfViewContorller?.present(hostingController, animated: true, completion: nil)
    }
    
    private func observeFiledownload(url: URL) {
        let c = NSFileCoordinator()
        c.coordinate(readingItemAt: url, options: [], error: nil) { newURL in
            loadPdf(url: newURL)
        }
    }
    
    func onNextPage() {
        var cur = pdfViewContorller?.getCurrentPage() ?? -1
        if cur < 0 {
            return
        }
        let maxPage = (pdfDocument?.pageCount ?? 0) - 1
        if cur < maxPage {
            cur += 1
            pdfViewContorller?.goToPage(page: cur)
        }
    }
    
    func onPrevPage() {
        var cur = pdfViewContorller?.getCurrentPage() ?? -1
        if cur <= 0 {
            return
        }

        cur -= 1
        pdfViewContorller?.goToPage(page: cur)
    }
    
    func invite() {
        peerManager.invite()
    }
    
    func advertise() {
        peerManager.advertise()
    }
}
