import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var networkStateService: NetworkStateService?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        let usersVC = UsersViewController()
        let signUpVC = SignUpViewController()
        
        let size = CGSize(width: 86, height: 24)
    
        let usersImage = UIImage(named: "usersButton")?.resized(to: size)
        let usersImageSelected = UIImage(named: "usersButtonH")?.resized(to: size)
        let signUpImage = UIImage(named: "signUpButton")?.resized(to: size)
        let signUpImageSelected = UIImage(named: "signUpButtonH")?.resized(to: size)
        
        usersVC.tabBarItem = UITabBarItem(title: "", image: usersImage, selectedImage: usersImageSelected)
        
        signUpVC.tabBarItem = UITabBarItem(title: "", image: signUpImage, selectedImage: signUpImageSelected)

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [usersVC, signUpVC]
       
        tabBarController.tabBar.backgroundColor = .systemGray6
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()

        networkStateService = NetworkStateService()
        networkStateService?.startMonitoring()
    }

    
    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}

