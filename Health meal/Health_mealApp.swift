import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {

        FirebaseApp.configure()
        if let path = Bundle.main.path(
            forResource: "GoogleService-Info",
            ofType: "plist"
        ) {
            print("FOUND:", path)

            if let dict = NSDictionary(contentsOfFile: path) {
                print(dict)
            }
        } else {
            print("PLIST NOT FOUND")
        }
        return true
    }
}

@main
struct HealthApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                FirstView()
            }
        }
    }
}
