//
//  PeerManager.swift
//  DuoScore
//

import SwiftUI
import MultipeerConnectivity

class PeerManager : NSObject {
    let session: MCSession
    let peerID: MCPeerID
    var advertiser: MCNearbyServiceAdvertiser?
    
    override init() {
        peerID = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        super.init()
        session.delegate = self
    }
    
    func invite() {
        let browser = MCBrowserViewController(serviceType: "DuoScore", session: session)
        browser.delegate = self
        
        getRootViewController()?.present(browser, animated: true, completion: nil)
    }
    
    func getRootViewController() -> UIViewController? {
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let window = windowScenes?.windows.first
        return window?.rootViewController
    }
    
    
    func advertise() {
        advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: "DuoScore")
        advertiser?.delegate = self
        advertiser?.startAdvertisingPeer()
    }
    
    func stopAdvertise() {
        advertiser?.stopAdvertisingPeer()
        advertiser = nil
    }
}

extension PeerManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: (any Error)?) {
    }
}

extension PeerManager: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        //invitationHandler(true, session)
        
        let alert = UIAlertController(title: "Allow Connection?", message: "Allow Connection from \(peerID.displayName)", preferredStyle: .alert)
        
        let delete = UIAlertAction(title: "Allow", style: .default, handler: { (action) -> Void in
            invitationHandler(true, self.session)
            print("Allow")
        })
        
        let cancel = UIAlertAction(title: "Deny", style: .cancel, handler: { (action) -> Void in
            invitationHandler(false, self.session)
            print("Deny")
        })
        
        alert.addAction(delete)
        alert.addAction(cancel)
        
        getRootViewController()?.present(alert, animated: true, completion: nil)
    }
}

extension PeerManager: MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true)
    }
}
