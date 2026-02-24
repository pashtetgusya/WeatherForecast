import UIKit
import Swinject

// MARK: - Application dependency injection assembly

/// Класс, отвечающий за регистрацию и сборку зависимостей приложения.
final class AppAssembly {
    
    // MARK: DI assemly protocol implementation
    
    /// Выполняет регистрацию зависимостей в контейнере.
    /// - Parameter diContainer: контейнер для регистрации зависимостей.
    func assemble(in diContainer: Container) {
        LaunchAssembly().assemble(in: diContainer)
        WeatherAssembly().assemble(in: diContainer)
        
        diContainer
            .register(AppCoordinator.self) { _ in
                MainActor.assumeIsolated {
                    let navController = UINavigationController()
                    let coordinator = AppCoordinator(di: diContainer, navController: navController)
                    
                    return coordinator
                }
            }
            .implements(LaunchCoordinator.self)
            .inObjectScope(.container)
        
        diContainer
            .register(UserLocationService.self) { _ in
                UserLocationServiceImpl()
            }
            .inObjectScope(.container)
        
        diContainer
            .register(HTTPClient.self) { _ in
                HTTPClientImpl()
            }
        
        diContainer
            .register(WeatherService.self) { resolver in
                guard
                    let httpClient = resolver.resolve(HTTPClient.self)
                else { fatalError("WeatherService depedencies not registered in DI container") }
                
                let weatherService = WeatherServiceImpl(httpClient: httpClient)
                
                return weatherService
            }
    }
}
