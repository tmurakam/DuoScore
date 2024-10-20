//
//  ContentView.swift
//  DuoScore
//

import SwiftUI
import PDFKit

struct PdfContentView: View {
    var body: some View {
        PdfView(urlString: "ballade4")
    }
}

struct PdfView: UIViewRepresentable {
    private let url: URL
    private let pdfView: PDFView
    
    init(urlString: String) {
        self.url = Bundle.main.url(forResource: urlString, withExtension: "pdf")!
        self.pdfView = PDFView()
    }
    
    func makeUIView(context: Context) -> PDFView {
        pdfView.document = PDFDocument(url: url)
        pdfView.autoScales = true
        pdfView.displayMode = .singlePage
        pdfView.backgroundColor = .clear
        
        pdfView.window?.rootViewController = KeyTestController(rootView: self)
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
        //
    }
    
    func nextPage() {
        pdfView.goToNextPage(self)
    }
    
    func prevPage() {
        pdfView.goToPreviousPage(self)
    }
}

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


#Preview {
    PdfContentView()
}
