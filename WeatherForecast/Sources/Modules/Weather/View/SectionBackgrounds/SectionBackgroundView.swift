import UIKit

// MARK: - Section background view

/// Вью фона секции коллекции.
final class SectionBackgroundView: UICollectionReusableView {
    
    // MARK: Sublayers
    
    private let backgroundGradientLayer = CAGradientLayer()
    
    // MARK: Initialization
    
    /// Создает новый экзепляр класса.
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setupAppearance()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { nil }
}

// MARK: - Life cycle

extension SectionBackgroundView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundGradientLayer.frame = bounds
    }
}

// MARK: - Setup functions

private extension SectionBackgroundView {
    
    /// Выполняет добавление `view`-компонентов.
    func addSubviews() {
        layer.insertSublayer(backgroundGradientLayer, at: 0)
    }
    
    /// Выполняет настройку `view`-компонентов.
    func setupAppearance() {
        clipsToBounds = true
        layer.cornerRadius = 25
        
        backgroundGradientLayer.colors = [
            UIColor(resource: .cardBlueGradient).cgColor,
            UIColor(resource: .cardLightBlueGradient).cgColor
        ]
        backgroundGradientLayer.locations = [0.0, 1.0]
        backgroundGradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        backgroundGradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
    }
}
