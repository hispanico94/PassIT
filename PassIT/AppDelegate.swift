import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let jsonFile: JsonFile = JsonReader.readJson()
        let passes = jsonFile.passes
        
        let mapViewController = MapViewController(passes: passes)
        mapViewController.tabBarItem = UITabBarItem(title: "Map", image: UIImage(named: "map_tab_bar_icon"), tag: 0)
        let passTableViewController = PassTableViewController(passes: passes)
        passTableViewController.tabBarItem = UITabBarItem(title: "List", image: UIImage(named: "list_tab_bar_icon"), tag: 1)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [mapViewController, passTableViewController]
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }
}

