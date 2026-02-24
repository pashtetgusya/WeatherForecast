import UIKit
import Kingfisher

// MARK: - Hourly weather cell

/// Ячейка отображения прогноза погоды за час.
final class HourlyWeatherCell: UICollectionViewCell {
    
    // MARK: Sublayers
    
    private let backgroundGradientLayer = CAGradientLayer()
    
    // MARK: Subviews
    
    private let hourLabel = UILabel()
    private let tempLabel = UILabel()
    private let iconImageView = UIImageView()
    
    // MARK: Properties
    
    private let measurementFormatter = MeasurementFormatter()
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setupAppearance()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
}

// MARK: - Life cycle

extension HourlyWeatherCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundGradientLayer.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconImageView.kf.cancelDownloadTask()
    }
}

// MARK: - Configure functions

extension HourlyWeatherCell {
    
    /// Выполнят настройку ячейке на основе переданной моделе.
    /// - Parameter model: модель для настройки ячейки.
    func setup(with model: WeatherModel.HourlyWeather) {
        let tempMeasurement = Measurement(value: model.temperature, unit: UnitTemperature.celsius)
        tempLabel.text = measurementFormatter.string(from: tempMeasurement)
        hourLabel.text = model.time
        iconImageView.kf.setImage(with: URL(string: model.iconURL))
    }
}

// MARK: - Setup functions

private extension HourlyWeatherCell {
    
    /// Выполняет добавление `view`-компонентов.
    func addSubviews() {
        contentView.addSubview(hourLabel)
        contentView.addSubview(tempLabel)
        contentView.addSubview(iconImageView)
        
        contentView.layer.insertSublayer(backgroundGradientLayer, at: 0)
    }
    
    /// Выполняет настройку `view`-компонентов.
    func setupAppearance() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 25
        
        backgroundGradientLayer.colors = [
            UIColor(resource: .cardBlueGradient).cgColor,
            UIColor(resource: .cardLightBlueGradient).cgColor
        ]
        backgroundGradientLayer.locations = [0.0, 1.0]
        backgroundGradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        backgroundGradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        
        hourLabel.textAlignment = .center
        hourLabel.textColor = .init(resource: .whiteText)
        hourLabel.font = .systemFont(ofSize: 14, weight: .bold)
        
        tempLabel.textAlignment = .center
        tempLabel.textColor = .init(resource: .whiteText)
        tempLabel.font = .systemFont(ofSize: 12, weight: .bold)
        
        iconImageView.contentMode = .scaleAspectFit
    }
    
    /// Выполняет настройку констрейнтов.
    func setupConstraints() {
        hourLabel.translatesAutoresizingMaskIntoConstraints = false
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hourLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            hourLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hourLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            iconImageView.topAnchor.constraint(equalTo: hourLabel.bottomAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            iconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor),
            
            tempLabel.topAnchor.constraint(greaterThanOrEqualTo: iconImageView.bottomAnchor),
            tempLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            tempLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tempLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
