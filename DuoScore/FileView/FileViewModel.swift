//
//  FileViewModel.swift
//  DuoScore
//

import SwiftUI

struct Score: Identifiable {
    let id = UUID()
    let name: String
}

class FileViewModel : ObservableObject {
    @Published var scores: [Score] = []
    
    init() {
        refresh()
    }
    
    func refresh() {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Can't get document directory")
            return
        }
        
        do {
            let fileUrls = try FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil, options: [])
            
            self.scores = fileUrls.map {
                Score(name: $0.lastPathComponent)
            }
        } catch {
            print("Failed to get files: \(error)")
        }
    }
    
    func onSelect(score: Score) {
        
    }
    
    func chooseFileToImport() {
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
                            self.importFile(url: url)
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
        getRootViewController()?.present(hostingController, animated: true, completion: nil)
    }
    
    func getRootViewController() -> UIViewController? {
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let window = windowScenes?.windows.first
        return window?.rootViewController
    }
    
    private func observeFiledownload(url: URL) {
        let c = NSFileCoordinator()
        c.coordinate(readingItemAt: url, options: [], error: nil) { newURL in
            importFile(url: newURL)
        }
    }
    
    private func importFile(url: URL) {
        let fileManager = FileManager.default
        guard let dir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Can't get document directory")
            return
        }

        let filename = url.lastPathComponent
        let dest = dir.appendingPathComponent(filename)
        
        do {
            if fileManager.fileExists(atPath: dest.path) {
                try fileManager.removeItem(at: dest)
            }

            try fileManager.copyItem(at: url, to: dest)
        } catch {
            showAlert(title: "Error", message: "\(error)")
        }

        refresh()
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        getRootViewController()?.present(alert, animated: true, completion: nil)
    }
}
