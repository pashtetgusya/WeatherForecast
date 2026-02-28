import UIKit

// MARK: - Application coodrinator

/// Класс, реализующий интерфейс координатора и
/// являющийся главным координатором приложения.
@MainActor final class AppCoordinator: NSObject, Sendable {
    
    // MARK: Properties
    
    let diContainer: AppDIContainer
    var childCoordinators: [Coordinator] = []
    var navController: UINavigationController
    var didFinish: ((Coordinator) -> Void)?
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameter diContainer: контейнер с зависимостями.
    /// - Parameter navController: навигационный контроллер.
    init(
        di diContainer: AppDIContainer,
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
        let viewController = LaunchAssembly.build(
            locationService: diContainer.locationService,
            coordinator: self
        )
        navController.setNavigationBarHidden(true, animated: false)
        navController.viewControllers = [viewController]
    }
    
    func resetToRoot() -> Self {
        childCoordinators.forEach { $0.resetToRoot(animated: false) }
        
        return self
    }
}

// MARK: - Launch coordinator protocol implementation

extension AppCoordinator: LaunchCoordinator {
    
    func presentWeatherView(for userLocation: UserLocation) {
        let viewController = WeatherAssembly.build(
            userLocation: userLocation,
            weatherService: diContainer.weatherService
        )
        navController.pushViewController(viewController, animated: true)
    }
}
