//
//  ContentView.swift
//  DuoScore
//

import SwiftUI
import PDFKit

struct PDFContentView: View {
    @State private var pdfDocument: PDFDocument?

    var body: some View {
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
    }
    
    private func loadPDF() {
        let url = Bundle.main.url(forResource: "ballade4", withExtension: "pdf")!
        pdfDocument = PDFDocument(url: url)
    }
}

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
    
    func nextPage() {
        //pdfView.goToNextPage(self)
    }
    
    func prevPage() {
        //pdfView.goToPreviousPage(self)
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
}

#Preview {
    PDFContentView()
}
