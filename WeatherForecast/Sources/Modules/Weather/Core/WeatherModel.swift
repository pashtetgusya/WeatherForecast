import Foundation

// MARK: - Weather model

/// Модель экрана прогноза погоды.
enum WeatherModel {
    
    // MARK: Section
    
    /// Структура, описывающия секцию прогноза погоды.
    struct Section {
        
        // MARK: Section type
        
        /// Тип секции прогноза погоды.
        enum `Type`: Hashable {
            
            // MARK: Cases
            
            case currentWeather
            case hourlyWeather(day: String)
        }
        
        // MARK: Section row
        
        /// Ячейка секции прогноза погоды.
        enum Row: Hashable {
            
            // MARK: Cases
            
            case currentWeather(model: WeatherModel.CurrentWeather)
            case hourlyWeather(model: WeatherModel.HourlyWeather)
        }
        
        // MARK: Properties
        
        let type: Section.`Type`
        let rows: [Section.Row]
    }
    
    // MARK: Current weather row model
    
    /// Структура, описывающая прогноз погоды на текущий момент времени.
    struct CurrentWeather: Hashable {
        
        // MARK: Properties
        
        let locationName: String
        let weatherType: String
        let currentTemperature: Double
        let maxTemperature: Double
        let minTemperature: Double
        
        // MARK: Initialization
        
        /// Создает новый экземпляр структуры.
        init(
            currentWeatherDTO: CurrentWeatherDTO,
            averageForecastDTO: DailyWeatherDTO.DailyForecastsDTO.DailyForecastDTO.AverageForecastDTO
        ) {
            self.locationName = currentWeatherDTO.location.name
            self.weatherType = currentWeatherDTO.forecast.weatherType.name
            self.currentTemperature = currentWeatherDTO.forecast.temperatureInCelsius
            self.maxTemperature = averageForecastDTO.maxTemperatureInCelcius
            self.minTemperature = averageForecastDTO.minTemperatureInCelcius
        }
    }
    
    // MARK: Hourly weather row model
    
    /// Структура, описывающая прогноз погоды за час.
    struct HourlyWeather: Hashable {
        
        // MARK: Properties
        
        let time: String
        let temperature: Double
        let iconURL: String
        
        // MARK: Initialization
        
        /// Создает новый экземпляр структуры.
        init(hourlyWeaherDTO: DailyWeatherDTO.DailyForecastsDTO.DailyForecastDTO.HourlyForecastDTO) {
            let timeInterval = TimeInterval(hourlyWeaherDTO.timeEpoch)
            let date = Date(timeIntervalSince1970: timeInterval)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            
            self.time = dateFormatter.string(from: date)
            self.temperature = hourlyWeaherDTO.temperatureInCelsius
            self.iconURL = "https://" + String(hourlyWeaherDTO.weatherType.iconURL.dropFirst(2))
        }
    }
}
