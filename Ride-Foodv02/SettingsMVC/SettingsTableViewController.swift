import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var topLabel: UILabel! { didSet {
        topLabel.font = UIFont.SFUIDisplaySemibold(size: 15)
    }}
    
    @IBOutlet weak var goBackView: UIView! { didSet {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismiss(_:)))
        goBackView.addGestureRecognizer(tapGesture)
    }}

    @objc
    private func dismiss(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            dismiss(animated: true)
        }
    }
}
