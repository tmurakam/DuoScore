//
//  FileView.swift
//  DuoScore
//

import SwiftUI

struct FileView: View {
    @StateObject private var viewModel = FileViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.scores) { item in
                NavigationLink {
                    ScoreContentView(url: item.url)
                } label: {
                    Text(item.name)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        viewModel.chooseFileToImport()
                    }) {
                        Image(systemName: "icloud.and.arrow.down")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu(content: {
                        Button(action: { viewModel.invite() }) {
                            Text("Invite secondary device")
                        }
                        .disabled(PeerManager.shared.isConnected())
                        
                        Button(action: { viewModel.advertise() }) {
                            Text("Advertise as secondary device")
                        }
                        .disabled(PeerManager.shared.isConnected())
                        
                        Button(action: { viewModel.disconnect() }) {
                            Text("Disconnect")
                        }
                        .disabled(!PeerManager.shared.isConnected())
                    }) {
                        Image(systemName: "point.3.filled.connected.trianglepath.dotted")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu(content: {
                        NavigationLink {
                            viewModel.getHelpView()
                        } label: {
                            Text("Help")
                        }
                    }) {
                        Image(systemName: "questionmark.circle")
                    }
                }
            }
        }
    }
}

#Preview {
    FileView()
}
