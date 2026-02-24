import Foundation

// MARK: - Launch coordinator

/// Интерфейс координатора стартового экрана.
protocol LaunchCoordinator: Coordinator {
    
    /// Отображает экран погоды для переданного местоположения пользователя..
    /// - Parameter userLocation: местоположение пользователя по которому отображается прогноз погоды.
    func presentWeatherView(for userLocation: UserLocation)
}
