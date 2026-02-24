import Foundation
import Swinject

// MARK: - Launch dependency injection assembly

/// Класс, отвечающий за регистрацию и сборку зависимостей стартового экрана.
final class LaunchAssembly {
    
    // MARK: DI assemly protocol implementation
    
    /// Выполняет регистрацию зависимостей в контейнере.
    /// - Parameter diContainer: контейнер для регистрации зависимостей.
    func assemble(in diContainer: Container) {
        diContainer
            .register(LaunchViewModel.self) { resolver in
                guard
                    let locationService = resolver.resolve(UserLocationService.self),
                    let coordinator = resolver.resolve(LaunchCoordinator.self)
                else { fatalError("LaunchViewModel depedencies not registered in DI container") }
                    
                let viewModel = LaunchViewModel(
                    locationService: locationService,
                    coordinator: coordinator
                )
                
                return viewModel
            }
        
        diContainer
            .register(LaunchViewController.self) { resolver in
                guard
                    let viewModel = resolver.resolve(LaunchViewModel.self)
                else { fatalError("LaunchViewController depedencies not registered in DI container") }
                
                let viewController = LaunchViewController(viewModel: viewModel)
                
                return viewController
            }
    }
}
