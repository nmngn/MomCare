//

import UIKit

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSwipeToBack()
    }
    
    // MARK: - Swipe-to-Back Setup
    private func setupSwipeToBack() {
        // Ensure the navigation controller exists
        guard let navigationController = navigationController else { return }
        
        // Enable the interactive pop gesture
        navigationController.interactivePopGestureRecognizer?.isEnabled = true
        navigationController.interactivePopGestureRecognizer?.delegate = self
    }
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // Allow swipe-to-back only if there's more than one view controller in the stack
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}
