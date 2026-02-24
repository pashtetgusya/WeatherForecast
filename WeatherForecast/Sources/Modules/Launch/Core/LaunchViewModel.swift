import Foundation
import Combine

// MARK: - Launch view model

/// Вью модель для вью контроллера стартового экрана,
final class LaunchViewModel {
    
    // MARK: Properties
    
    private let locationService: UserLocationService
    private weak let coordinator: LaunchCoordinator?
    
    @Published var isLoading: Bool
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    init(
        locationService: UserLocationService,
        coordinator: LaunchCoordinator
    ) {
        self.locationService = locationService
        self.coordinator = coordinator
        
        self.isLoading = false
    }
}

// MARK: - Load functions

extension LaunchViewModel {
    
    /// Выполняет загрузку текущей локации пользователя.
    ///
    /// При необходимости запрашивает разрешение на
    /// использование местоположения пользователя
    func loadUserLocation() {
        Task { [weak self] in
            guard let self else { return }
            
            defer { isLoading = false }
            isLoading = true
            
            // Проверяем статус разрешения на использование местоположения пользователя,
            // если разрешение дано, то пробуем получить текущее местоположение пользователя.
            // В случае успеха используем его,
            // во всех остальных случаях используем местоположение по умолчанию.
            do {
                let permissionStatus = await locationService.getUserLocationPermissionStatus()
                let userLocation = switch permissionStatus {
                    case .authorized: try await locationService.getCurrentUserLocation()
                    case .notAuthorized: UserLocation.default
                }
                
                await coordinator?.presentWeatherView(for: userLocation)
            }
            catch {
                await coordinator?.presentWeatherView(for: UserLocation.default)
            }
        }
    }
}
