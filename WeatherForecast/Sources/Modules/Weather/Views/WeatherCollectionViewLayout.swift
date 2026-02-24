import UIKit

// MARK: - Weather collection view layout

/// Лейаут коллекции отображения прогноза погоды.
final class WeatherCollectionViewLayout: UICollectionViewCompositionalLayout {
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    init() {
        super.init { sectionIndex, _ in
            switch sectionIndex {
                case 0: Self.createFullWidthSquareSection()
                default: Self.createHorizontalScrollSection()
            }
        }
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { nil }
}

// MARK: - Section build functions

private extension WeatherCollectionViewLayout {
    
    /// Создает секцию с ячейкой на всю ширину.
    static func createFullWidthSquareSection() -> NSCollectionLayoutSection {
        let itemLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
        
        let groupLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.65)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupLayoutSize,
            subitems: [item]
        )
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 10, leading: 16, bottom: 10, trailing: 16
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        
        return section
    }
    
    /// Создает секцию с горизонтальным скроллом и небольшими ячейками.
     static func createHorizontalScrollSection() -> NSCollectionLayoutSection {
        let itemLayoutSize = NSCollectionLayoutSize(
            widthDimension: .absolute(60),
            heightDimension: .absolute(110)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
        
        let groupLayoutSize = NSCollectionLayoutSize(
            widthDimension: .absolute(60),
            heightDimension: .absolute(110)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupLayoutSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 8, leading: 16, bottom: 16, trailing: 16
        )
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
}
