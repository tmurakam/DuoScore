//
//  PDFViewController.swift
//  DuoScore
//

import SwiftUI
import PDFKit

struct PdfViewWrapper: UIViewControllerRepresentable {
    var viewModel: ScoreContentViewModel

    init(pdfContentViewModel: ScoreContentViewModel) {
        self.viewModel = pdfContentViewModel
    }

    func makeUIViewController(context: Context) -> PdfViewController {
        let vc = PdfViewController()
        vc.viewModel = viewModel
        viewModel.setPdfViewController(pdfViewController: vc)  // TODO: circular
        return vc
    }
    
    func updateUIViewController(_ uiViewController: PdfViewController, context: Context) {
        uiViewController.viewModel = viewModel
    }
}

class PdfViewController: UIViewController {
    var pdfView = PDFView()

    var viewModel: ScoreContentViewModel? {
        didSet {
            pdfView.document = viewModel?.pdfDocument
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
        pdfView.displayBox = .mediaBox
        
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
        //let ry = Double(location.y) / pdfView.frame.height
        
        //print("rx: \(rx), ry: \(ry)")

        if (rx > 0.7) {
            viewModel?.onNextPage()
        } else if (rx < 0.3) {
            viewModel?.onPrevPage()
        } else {
            viewModel?.toggleToolBar()
        }
        setScaleFactor()
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        for press in presses {
            if press.key?.charactersIgnoringModifiers == UIKeyCommand.inputLeftArrow {
                print("press prev")
            }
            if press.key?.charactersIgnoringModifiers == UIKeyCommand.inputRightArrow {
                print("press next")
            }
        }
    }
    
    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        for press in presses {
            if press.key?.charactersIgnoringModifiers == UIKeyCommand.inputLeftArrow {
                print("release prev")
                viewModel?.onPrevPage()
            }
            if press.key?.charactersIgnoringModifiers == UIKeyCommand.inputRightArrow {
                print("release next")
                viewModel?.onNextPage()
            }
        }
    }
    
    func getCurrentPage() -> Int {
        if let curPage = pdfView.currentPage {
            let idx = pdfView.document?.index(for: curPage) ?? 0
            return idx
        } else {
            return -1
        }
    }
    
    func goToPage(page: Int) {
        if let page = pdfView.document?.page(at: page) {
            pdfView.go(to: page)
        }
    }
    
    /*
    func goToNextPage() {
        pdfView.goToNextPage(self)
    }
    
    func goToPreviousPage() {
        pdfView.goToPreviousPage(self)
    }
    */
    
    func setPdfDocument(doc: PDFDocument) {
        self.pdfView.document = doc
        setScaleFactor()
    }
  
    private func setScaleFactor() {
        if let page = pdfView.document?.page(at: 0) {
            let pdfViewBounds = pdfView.bounds
            let pageBounds = page.bounds(for: .mediaBox)
            let scale = min(pdfViewBounds.width / pageBounds.width, pdfViewBounds.height / pageBounds.height)
            if scale > 0 {
                pdfView.autoScales = false
                pdfView.scaleFactor = scale
                pdfView.minScaleFactor = scale
                pdfView.maxScaleFactor = scale
            }
        }
    }
}
