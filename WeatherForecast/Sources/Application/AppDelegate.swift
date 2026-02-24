import UIKit
import Swinject

// MARK: - Application delegate

@main final class AppDelegate: UIResponder {
    
    // MARK: Properties
    
    var window: UIWindow?
    
    private var appDIContainer: Container?
    private var appCoordinator: Coordinator?
}

// MARK: - UI application delegate protocol implementation

extension AppDelegate: UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        setupAppDIContainer()
        setupAppCoordinator()
        setupAppRootViewController()
        
        return true
    }
}

// MARK: - Setup functions

private extension AppDelegate {
    
    /// Выполняет настройку контейнера с зависимостями приложения.
    func setupAppDIContainer() {
        let container = Container()
        appDIContainer = container
        
        let appAssembly = AppAssembly()
        appAssembly.assemble(in: container)
    }
    
    /// Выполняет настройку координатора приложения.
    func setupAppCoordinator() {
        appCoordinator = appDIContainer?.resolve(AppCoordinator.self)
        appCoordinator?.start()
    }
    
    /// Выполняет настройку главного контроллера приложения.
    func setupAppRootViewController() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = appCoordinator?.navController
        window?.makeKeyAndVisible()
    }
}
