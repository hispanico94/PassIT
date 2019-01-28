import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let factory: ViewControllerFactory = DependencyContainer()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        window?.rootViewController = factory.makeInitialViewControllers()
        window?.makeKeyAndVisible()
        
        return true
    }
}

