//
//  PDFViewController.swift
//  DuoScore
//

import SwiftUI
import PDFKit

struct PDFViewWrapper: UIViewControllerRepresentable {
    var pdfDocument: PDFDocument

    init(pdfDocument: PDFDocument) {
        self.pdfDocument = pdfDocument
    }

    func makeUIViewController(context: Context) -> PDFViewController {
        let vc = PDFViewController()
        vc.pdfDocument = pdfDocument
        return vc
    }
    
    func updateUIViewController(_ uiViewController: PDFViewController, context: Context) {
        uiViewController.pdfDocument = pdfDocument
    }
}

class PDFViewController: UIViewController {
    var pdfView = PDFView()
    var pdfDocument: PDFDocument? {
        didSet {
            pdfView.document = pdfDocument
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPDFView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupPDFView() {
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)

        pdfView.backgroundColor = .clear
        pdfView.autoScales = true
        pdfView.displayMode = .singlePage
        
        NSLayoutConstraint.activate([
            pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pdfView.topAnchor.constraint(equalTo: view.topAnchor),
            pdfView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: pdfView)
        //print("Tapped at: \(location)")

        let rx = Double(location.x) / pdfView.frame.width
        let ry = Double(location.y) / pdfView.frame.height
        
        //print("rx: \(rx), ry: \(ry)")

        if (ry < 0.25) {
            showMenu()
        }
        else if (rx > 0.75) {
            pdfView.goToNextPage(self)
        } else if (rx < 0.25) {
            pdfView.goToPreviousPage(self)
        }
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        for press in presses {
            if press.key?.charactersIgnoringModifiers == UIKeyCommand.inputLeftArrow {
                print("press prev")
                //pdfView.prevPage()
            }
            if press.key?.charactersIgnoringModifiers == UIKeyCommand.inputRightArrow {
                print("press next")
                //pdfView.nextPage()
            }
        }
    }
    
    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        for press in presses {
            if press.key?.charactersIgnoringModifiers == UIKeyCommand.inputLeftArrow {
                print("release prev")
                pdfView.goToPreviousPage(self)
            }
            if press.key?.charactersIgnoringModifiers == UIKeyCommand.inputRightArrow {
                print("release next")
                pdfView.goToNextPage(self)
            }
        }
    }
    
    private func showMenu() {
        let picker = DocumentPicker { urls in
            if let url = urls.first {
                do {
                    let isReachable = try url.checkResourceIsReachable()
                    if !isReachable {
                        print("Attempt to download from iCloud")
                        try FileManager.default.startDownloadingUbiquitousItem(at: url)
                        self.observeFiledownload(url: url)
                    } else {
                        self.loadPDF(url: url)
                    }
                } catch {
                    print("Error: \(error)")
                }
            }
        }
        
        let hostingController = UIHostingController(rootView: picker)
        self.present(hostingController, animated: true, completion: nil)
    }
    
    private func loadPDF(url: URL) {
        let doc = PDFDocument(url: url)
        if doc == nil {
            print("Failed to load PDF: document: \(url)")
        } else {
            self.pdfDocument = doc
            self.pdfView.document = doc
        }
    }
    
    private func observeFiledownload(url: URL) {
        let c = NSFileCoordinator()
        c.coordinate(readingItemAt: url, options: [], error: nil) { newURL in
            loadPDF(url: newURL)
        }
    }
}
