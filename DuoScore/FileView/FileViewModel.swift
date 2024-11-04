//
//  FileViewModel.swift
//  DuoScore
//

import Foundation

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
}
