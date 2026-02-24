import UIKit

// MARK: - Launch view

/// Вью стартового экрана.
final class LaunchView: UIView {
    
    // MARK: Subviews
    
    private let imageView = UIImageView()
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    init() {
        super.init(frame: .zero)
        
        addSubviews()
        setupAppearance()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
}

// MARK: - Public functions

extension LaunchView {
    
    /// Выполняет запуск отображения процесса загрузки.
    func startLoading() {
        activityIndicatorView.startAnimating()
    }
    
    /// Выполняет остановку отображения процесса загрузки.
    func stopLoading() {
        activityIndicatorView.stopAnimating()
    }
}

// MARK: - Setup functions

private extension LaunchView {
    
    /// Выполняет добавление `view`-компонентов.
    func addSubviews() {
        addSubview(imageView)
        addSubview(activityIndicatorView)
    }
    
    /// Выполняет настройку `view`-компонентов.
    func setupAppearance() {
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(resource: .launchScreen)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// Выполняет настройку констрейнтов.
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -100)
        ])
    }
}
