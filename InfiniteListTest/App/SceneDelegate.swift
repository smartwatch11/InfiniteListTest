
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let vc = buildScene()
        let nav = UINavigationController(rootViewController: vc)
        nav.setupNavBarColor()
        window.rootViewController = nav
        window.makeKeyAndVisible()
        self.window = window
    }
    
    func buildScene() -> UIViewController {
        let mainView = ViewController()
        let apiHandler = ApiFetchHandler()
        let presenter = MainPresenter(view: mainView, apiHandler: apiHandler)
        mainView.presenter = presenter
        return mainView
    }
    
}
