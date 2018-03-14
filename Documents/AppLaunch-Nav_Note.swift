
class AppDelegate: UIResponder, UIApplicationDelegate
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) {

let welcomeViewController = WelcomeViewController()
let rootViewController = NavigationController(rootViewController: welcomeViewController)

window.rootViewController = rootViewController

//Display window and WelcomeView
window.makeKeyAndVisible()

}

####### customise NavigationController #######

class NavigationController: UINavigationController {
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .default
	}
	
	override init(rootViewController: UIViewController) {
		super.init(rootViewController: rootViewController)
		
//Define back button icon
		self.configureBackButtonItem()
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
… …
}

########### UIViewController #######
override func viewDidLoad() {
		super.viewDidLoad()

		self.navigationItem.title = "Weather daily forecast"
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:  imageLiteral(resourceName: "nav_hour_button"), style: .plain, target: self, action: #selector(hourButtonTapped))

}

   @objc fileprivate func hourButtonTapped() {
		guard !WeatherDataInfo.shared.isEmpty else {
			return
		}
		//Push to next view
		self.performSegue(withIdentifier: hourlyViewSegue, sender: nil)
	}

//Before push view to set next init varible
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == self.hourlyViewSegue {
			// Get reference to the destination view controller
			let vc = segue.destination as! HourlyViewController
			vc.viewModel = self.viewModel
		}
	}
}