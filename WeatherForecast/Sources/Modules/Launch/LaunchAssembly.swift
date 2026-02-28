import UIKit

// MARK: - Launch dependency injection assembly

/// Класс, отвечающий за сборку стартового экрана.
final class LaunchAssembly {
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    private init() { }
    
    // MARK: Build function
    
    /// Выполняет сборку стартового экрана.
    /// - Returns: стартовый экран.
    static func build(
        locationService: UserLocationService,
        coordinator: LaunchCoordinator
    ) -> UIViewController {
        let viewModel = LaunchViewModel(
            locationService: locationService,
            coordinator: coordinator
        )
        let viewController = LaunchViewController(viewModel: viewModel)
        
        return viewController
    }
}
