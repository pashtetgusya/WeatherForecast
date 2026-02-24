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
                
                let calendar = Calendar.current
                let dateFormatter = DateFormatter()
                let currentDateTimeInterval = Int(Date.now.timeIntervalSince1970)
                let currentWeatherDTO = try await weatherService.getCurrentWeather(
                    latitude: userLocation.coordinate.latitude,
                    longitude: userLocation.coordinate.longitude
                )
                let weatherForecastDTO = try await weatherService.getWeahterForecast(
                    latitude: userLocation.coordinate.latitude,
                    longitude: userLocation.coordinate.longitude,
                    days: 3
                )
                
                guard
                    let averageForecastDTO = weatherForecastDTO.dailyForecasts.dailyForecastsDTO
                        .first(where: {
                            calendar.isDateInToday(dateFormatter.date(from: $0.date) ?? .now)
                        })?
                        .averageForecast
                else { return }
                
                let currentWeahterSection = WeatherModel.Section(
                    type: .currentWeather,
                    rows: [.currentWeather(model: WeatherModel.CurrentWeather(
                        currentWeatherDTO: currentWeatherDTO,
                        averageForecastDTO: averageForecastDTO
                    ))]
                )
                let hourlyWeatherSections = weatherForecastDTO.dailyForecasts.dailyForecastsDTO.map { dailyForecastDTO in
                    let hourlyWeatherModels = dailyForecastDTO.hourlyForecasts
                        .filter { $0.timeEpoch > currentDateTimeInterval }
                        .map { WeatherModel.HourlyWeather(hourlyWeaherDTO: $0) }
                    let hourlyWeatherSection = WeatherModel.Section(
                        type: .hourlyWeather(day: dailyForecastDTO.date),
                        rows: hourlyWeatherModels.map { .hourlyWeather(model: $0) }
                    )
                    
                    return hourlyWeatherSection
                }
                let weatherSections = [currentWeahterSection] + hourlyWeatherSections
                state = .loaded(weahterSections: weatherSections)
            }
            catch {
                state = .errorLoading
            }
        }
    }
}
