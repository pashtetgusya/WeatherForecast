import UIKit
import Combine

// MARK: - Launch view controller

/// Вью контроллер стартового экрана.
final class LaunchViewController: UIViewController {
    
    // MARK: Properties
    
    private let contentView: LaunchView
    private let viewModel: LaunchViewModel
    private var cancellables: Set<AnyCancellable>
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    init(viewModel: LaunchViewModel) {
        self.contentView = LaunchView()
        self.viewModel = viewModel
        self.cancellables = []
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { nil }
}

// MARK: - Life cycle

extension LaunchViewController {
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModelBindings()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        viewModel.loadUserLocation()
    }
}

// MARK: - Setup functions

private extension LaunchViewController {
    
    /// Выполняет настройку подписок на события вью модели.
    func setupViewModelBindings() {
        viewModel.$isLoading
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink { [weak self] isLoading in
                switch isLoading {
                    case true: self?.contentView.startLoading()
                    case false: self?.contentView.stopLoading()
                }
            }
            .store(in: &cancellables)
    }
}
