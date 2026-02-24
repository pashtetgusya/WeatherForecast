import UIKit

// MARK: - Weather view

/// Вью экрана прогноза погоды.
final class WeatherView: UIView {
    
    // MARK: Sublayers
    
    private let backgroundGradientLayer = CAGradientLayer()
    
    // MARK: Subviews
    
    let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: WeatherCollectionViewLayout()
    )
    
    // MARK: Properties
    
    let loadingConfiguration: UIContentUnavailableConfiguration = {
        var configuration = UIContentUnavailableConfiguration.loading()
        configuration.text = "Please wait..."
        configuration.secondaryText = "Fetching weather forecast."
        configuration.textProperties.color = .white
        configuration.secondaryTextProperties.color = .white
        
        return configuration
    }()
    var errorLoadingConfiguration: UIContentUnavailableConfiguration = {
        var buttonConfiguration = UIButton.Configuration.borderless()
        buttonConfiguration.title = "Retry"
        buttonConfiguration.image = UIImage(systemName: "arrow.clockwise")
        buttonConfiguration.baseForegroundColor = .white
        
        var configuration = UIContentUnavailableConfiguration.empty()
        configuration.text = "Oops..."
        configuration.secondaryText = "Failed to load weather forecast."
        configuration.textProperties.color = .white
        configuration.secondaryTextProperties.color = .white
        configuration.button = buttonConfiguration
        
        return configuration
    }()
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    init() {
        super.init(frame: .zero)
        
        addSubviews()
        setupAppearance()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { nil }
}

// MARK: - Life cycle

extension WeatherView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundGradientLayer.frame = bounds
    }
}

// MARK: - Setup functions

private extension WeatherView {
    
    /// Выполняет добавление `view`-компонентов.
    func addSubviews() {
        addSubview(collectionView)
        
        layer.insertSublayer(backgroundGradientLayer, at: 0)
    }
    
    /// Выполняет настройку `view`-компонентов.
    func setupAppearance() {
        backgroundGradientLayer.colors = [
            UIColor(resource: .backgroundBlueGradient).cgColor,
            UIColor(resource: .backgroundLightBlueGradient).cgColor
        ]
        backgroundGradientLayer.locations = [0.0, 1.0]
        backgroundGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        backgroundGradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        
        collectionView.allowsSelection = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.registerCell(CurrentWeatherCell.self)
        collectionView.registerCell(HourlyWeatherCell.self)
    }
    
    /// Выполняет настройку констрейнтов.
    func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
