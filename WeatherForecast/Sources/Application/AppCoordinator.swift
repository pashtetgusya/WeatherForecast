import UIKit
import Swinject

// MARK: - Application coodrinator

/// Класс, реализующий интерфейс координатора и
/// являющийся главным координатором приложения.
@MainActor final class AppCoordinator: NSObject, Sendable {
    
    // MARK: Properties
    
    let diContainer: Container
    var childCoordinators: [Coordinator] = []
    var navController: UINavigationController
    var didFinish: ((Coordinator) -> Void)?
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameter diContainer: контейнер с зависимостями.
    /// - Parameter navController: навигационный контроллер.
    init(
        di diContainer: Container,
        navController: UINavigationController
    ) {
        self.diContainer = diContainer
        self.navController = navController
        
        super.init()
    }
}
 
// MARK: - Coordinator protocol implementation

extension AppCoordinator: Coordinator {
    
    func start() {
        guard
            let launchViewController = diContainer.resolve(LaunchViewController.self)
        else { fatalError("LaunchViewController not registered in DI container") }
        
        navController.setNavigationBarHidden(true, animated: false)
        navController.viewControllers = [launchViewController]
    }
    
    func resetToRoot() -> Self {
        childCoordinators.forEach { $0.resetToRoot(animated: false) }
        
        return self
    }
}

// MARK: - Launch coordinator protocol implementation

extension AppCoordinator: LaunchCoordinator {
    
    func presentWeatherView(for userLocation: UserLocation) {
        guard
            let viewController = diContainer.resolve(
                WeatherViewController.self,
                argument: userLocation
            )
        else { fatalError("WeatherViewController not registered in DI container") }
        
        navController.pushViewController(viewController, animated: true)
    }
}
