import UIKit

class EnterPromocodeViewController: UIViewController {

    private var promocodeToolbar = PromocodeToolbar.initFromNib()
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(showToolbarView(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        promocodeToolbar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let window = UIApplication.shared.keyWindow else { return }
        promocodeToolbar.frame = CGRect(x: 0, y: window.bounds.height, width: window.bounds.width, height: SettingsConstant.toolbarHeight)
        promocodeToolbar.textField.becomeFirstResponder()
        window.addSubview(promocodeToolbar)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let window = UIApplication.shared.keyWindow else { return }
        promocodeToolbar.frame = CGRect(x: 0, y: window.bounds.height, width: window.bounds.width, height: SettingsConstant.toolbarHeight)
        promocodeToolbar.dismiss()
    }
    
    @objc
    private func showToolbarView(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let window = UIApplication.shared.keyWindow else { return }
        if let size = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            promocodeToolbar.frame.origin.y = window.frame.height - (size.height + SettingsConstant.toolbarHeight )
        }
    }

}


extension EnterPromocodeViewController: PromocodeToolbarDelegate {
    
    func activatePromocode() {
        promocodeToolbar.dismiss()
    }
    
}
