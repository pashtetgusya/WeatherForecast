import Foundation
import Combine

// MARK: - Weather view model

/// Вью модель для вью контроллера экрана прогноза погоды.
final class WeatherViewModel {
    
    /// Перечень статусов вью модели.
    enum State {
        
        // MARK: Cases
        
        case idle
        case loading
        case loaded(weahterSections: [WeatherModel.Section])
        case errorLoading
    }
    
    // MARK: Properties
    
    private let weatherService: WeatherService
    private let userLocation: UserLocation
    
    @Published var state: State
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    init(
        userLocation: UserLocation,
        weatherService: WeatherService
    ) {
        self.weatherService = weatherService
        self.userLocation = userLocation
        
        self.state = .idle
    }
}

// MARK: - Load functions

extension WeatherViewModel {
    
    /// Выполняет загрузку прогноза погоды.
    func loadWeather() {
        Task { [weak self] in
            guard let self else { return }
            
            do {
                state = .loading
                
                let currentWeatherDTO = try await weatherService.getCurrentWeather(
                    latitude: userLocation.coordinate.latitude,
                    longitude: userLocation.coordinate.longitude
                )
                let weatherForecastDTO = try await weatherService.getWeahterForecast(
                    latitude: userLocation.coordinate.latitude,
                    longitude: userLocation.coordinate.longitude,
                    days: 3
                )
                
                let currentWeahterSection = WeatherModel.Section(
                    type: .currentWeather,
                    rows: [.currentWeather(model: WeatherModel.CurrentWeather(
                        currentWeatherDTO: currentWeatherDTO,
                        averageForecastDTO: weatherForecastDTO.dailyForecasts.dailyForecastsDTO[0].averageForecast
                    ))]
                )
                
                let currentDateTimeInterval = Int(Date.now.timeIntervalSince1970)
                let hourlyWeatherTodayModels = weatherForecastDTO.dailyForecasts.dailyForecastsDTO[0]
                    .hourlyForecasts
                    .filter { $0.timeEpoch > currentDateTimeInterval }
                    .map { WeatherModel.HourlyWeather(hourlyWeaherDTO: $0) }
                let hourlyWeatherTomorrowModels = weatherForecastDTO.dailyForecasts.dailyForecastsDTO[1]
                    .hourlyForecasts[0...(24 - hourlyWeatherTodayModels.count)]
                    .map { WeatherModel.HourlyWeather(hourlyWeaherDTO: $0) }
                
                let hourlyWeatherModels = hourlyWeatherTodayModels + hourlyWeatherTomorrowModels
                let hourlyWeatherSection = WeatherModel.Section(
                    type: .hourlyWeather,
                    rows: hourlyWeatherModels.map { .hourlyWeather(model: $0) }
                )
                
                let weatherSections = [currentWeahterSection] + [hourlyWeatherSection]
                state = .loaded(weahterSections: weatherSections)
            }
            catch {
                state = .errorLoading
            }
        }
    }
}
