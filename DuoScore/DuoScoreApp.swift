//
//  DuoScoreApp.swift
//  DuoScore
//

import SwiftUI

@main
struct DuoScoreApp: App {
    var body: some Scene {
        WindowGroup {
            let url = Bundle.main.url(forResource: "ballade4", withExtension: "pdf")!
            PDFContentView(url: url)
        }
    }
}
