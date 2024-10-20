//
//  ContentView.swift
//  DuoScore
//

import SwiftUI
import PDFKit

struct PdfContentView: View {
    var body: some View {
        PdfViewWrapper(urlString: "ballade4")
    }
}

struct PdfViewWrapper: UIViewControllerRepresentable {
    private let url: URL
    private var pdfDocment: PDFDocument
    
    init(urlString: String) {
        self.url = Bundle.main.url(forResource: urlString, withExtension: "pdf")!
        self.pdfDocment = PDFDocument(url: url)!
    }
    
    func makeUIViewController(context: Context) -> PDFViewController {
        let vc = PDFViewController()
        vc.pdfDocument = pdfDocment
        return vc
    }
    
    func updateUIViewController(_ uiViewController: PDFViewController, context: Context) {
        uiViewController.pdfDocument = pdfDocment
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

/*
class KeyTestController: UIHostingController<PdfView> {
    private let pdfView: PdfView
    
    required override init(rootView: PdfView) {
        self.pdfView = rootView
        super.init(rootView: rootView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func becomeFirstResponder() -> Bool {
        true
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        for press in presses {
            if press.key?.charactersIgnoringModifiers == UIKeyCommand.inputLeftArrow {
                print("prev")
                //pdfView.prevPage()
            }
            if press.key?.charactersIgnoringModifiers == UIKeyCommand.inputRightArrow {
                print("next")
                //pdfView.nextPage()
            }
        }
    }

    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        for press in presses {
            if press.key?.charactersIgnoringModifiers == UIKeyCommand.inputLeftArrow {
                print("prev")
                pdfView.prevPage()
            }
            if press.key?.charactersIgnoringModifiers == UIKeyCommand.inputRightArrow {
                print("next")
                pdfView.nextPage()
            }
        }
    }
}
*/

#Preview {
    PdfContentView()
}
