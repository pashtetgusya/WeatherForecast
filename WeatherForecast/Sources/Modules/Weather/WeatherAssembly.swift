import UIKit

// MARK: - Weather dependency injection assembly

/// Класс, отвечающий за сборку экрана погоды.
final class WeatherAssembly {
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    private init() { }
    
    // MARK: Build function
    
    /// Выполняет сборку экрана погоды.
    /// - Parameters:
    ///   - userLocation: местоположение пользователя.
    /// - Returns: экран погоды.
    static func build(
        userLocation: UserLocation,
        weatherService: WeatherService
    ) -> UIViewController {
        let viewModel = WeatherViewModel(userLocation: userLocation, weatherService: weatherService)
        let viewController = WeatherViewController(viewModel: viewModel)
        
        return viewController
    }
}
