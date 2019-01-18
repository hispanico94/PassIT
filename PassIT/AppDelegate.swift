import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        guard
            let url = Bundle.main.url(forResource: "Passes", withExtension: "json"),
            let jsonFile = JsonFile(fromJsonWithUrl: url)
            else {
                fatalError("Unable to get the JsonFile from Passes.json")
        }
        
        let passes = jsonFile.passes
        
        let userLocation = UserLocation()
        
        let mapViewController = MapViewController(passes: passes, locationProvider: userLocation)
        mapViewController.tabBarItem = UITabBarItem(title: "Map", image: UIImage(named: "map_tab_bar_icon"), tag: 0)
        let passTableViewController = PassTableViewController(passes: passes, locationProvider: userLocation)
        passTableViewController.title = "Passes and Peaks"
        passTableViewController.tabBarItem = UITabBarItem(title: "List", image: UIImage(named: "list_tab_bar_icon"), tag: 1)
        let navigationController = UINavigationController(rootViewController: passTableViewController)
        
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [mapViewController, navigationController]
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }
}

