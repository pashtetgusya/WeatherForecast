import Foundation
import Swinject

// MARK: - Weather dependency injection assembly

/// Класс, отвечающий за регистрацию и сборку зависимостей экрана погоды.
final class WeatherAssembly {
    
    // MARK: DI assemly protocol implementation
    
    /// Выполняет регистрацию зависимостей в контейнере.
    /// - Parameter diContainer: контейнер для регистрации зависимостей.
    func assemble(in diContainer: Container) {
        diContainer
            .register(WeatherViewModel.self) { resolver, userLocation in
                guard
                    let weatehrService = resolver.resolve(WeatherService.self)
                else { fatalError("WeatherViewModel depedencies not registered in DI container") }
                
                let viewModel = WeatherViewModel(
                    userLocation: userLocation,
                    weatherService: weatehrService
                )
                
                return viewModel
            }
        
        diContainer
            .register(WeatherViewController.self) { (resolver: any Resolver, userLocation: UserLocation) in
                guard
                    let viewModel = resolver.resolve(WeatherViewModel.self, argument: userLocation)
                else { fatalError("WeatherViewController depedencies not registered in DI container") }
                
                let viewController = WeatherViewController(viewModel: viewModel)
                
                return viewController
            }
    }
}
