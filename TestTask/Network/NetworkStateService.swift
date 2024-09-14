import Foundation
import UIKit

class NetworkStateService {
    private let networkMonitor: NetworkMonitoring
    private var isConnectionVCPresented = false

    init(networkMonitor: NetworkMonitoring = NetworkMonitor.shared) {
        self.networkMonitor = networkMonitor
    }

    // MARK: - Network Monitoring

    public func startMonitoring() {
        networkMonitor.setPathUpdateHandler { [weak self] path in
            DispatchQueue.main.async {
                if path.status == .unsatisfied {
                    self?.handleNetworkDisconnected()
                } else {
                    self?.handleNetworkConnected()
                }
            }
        }
        networkMonitor.startMonitoring()
    }

    public func stopMonitoring() {
        networkMonitor.stopMonitoring()
    }

    // MARK: - UI Management

    private func getRootViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return nil
        }
        return windowScene.windows.first { $0.isKeyWindow }?.rootViewController
    }

    private func handleNetworkDisconnected() {
        guard !isConnectionVCPresented else { return }
        guard let presentingViewController = getRootViewController() else {
            return
        }

        let noConnectionVC = NoConnectionViewController()
        noConnectionVC.modalPresentationStyle = .fullScreen
        isConnectionVCPresented = true
        presentingViewController.present(noConnectionVC, animated: true, completion: nil)
    }

    private func handleNetworkConnected() {
        guard isConnectionVCPresented else { return }
        guard let presentingViewController = getRootViewController() else {
            return
        }
        presentingViewController.dismiss(animated: true, completion: nil)
        isConnectionVCPresented = false
    }
}
