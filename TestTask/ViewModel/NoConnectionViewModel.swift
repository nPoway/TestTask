import Foundation

class NoConnectionViewModel {

    var onConnectionStatusChanged: ((Bool) -> Void)?

    init() {
        NetworkMonitor.shared.setPathUpdateHandler { [weak self] path in
            let isConnected = path.status == .satisfied
            self?.onConnectionStatusChanged?(isConnected)
        }
        NetworkMonitor.shared.startMonitoring()
    }

    func isConnected() -> Bool {
        return NetworkMonitor.shared.isConnected
    }

    func retryConnection() -> Bool {
        return isConnected()
    }
}
