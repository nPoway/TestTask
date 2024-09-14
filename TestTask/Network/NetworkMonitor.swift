import Foundation
import Network

protocol NetworkMonitoring {
    var isConnected: Bool { get }
    func startMonitoring()
    func stopMonitoring()
    func setPathUpdateHandler(handler: @escaping (NWPath) -> Void)
}

class NetworkMonitor: NetworkMonitoring {
    
    static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .utility)
    
    private(set) var isConnected: Bool = false
    
    public func startMonitoring() {
        monitor.start(queue: queue)
    }
    
    public func stopMonitoring() {
        monitor.cancel()
    }
    public func setPathUpdateHandler(handler: @escaping (NWPath) -> Void) {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            handler(path)
        }
    }
    public func checkCurrentConnection() -> Bool {
            return monitor.currentPath.status == .satisfied
        }
}
