import UIKit

class EnterPromocodeViewController: UIViewController {

    @IBOutlet weak var checkmarkButton: UIButton!
    @IBOutlet weak var doneButton: UIButton! { didSet {
        doneButton.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 17)
    }}
    @IBOutlet weak var roundedView: RoundedView! { didSet {
        roundedView.cornerRadius = 15.0
        roundedView.colorToFill = #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1)
    }}
    @IBOutlet weak var promocodeLabel: UILabel! { didSet {
        promocodeLabel.font = UIFont.SFUIDisplaySemibold(size: 17)
    }}
    @IBOutlet weak var promocodeDescriptionLabel: UILabel! { didSet {
        promocodeDescriptionLabel.font = UIFont.SFUIDisplayLight(size: 17)
    }}
    @IBOutlet weak var imageView: UIImageView!
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
    
    func activate(promocode: String) {
        imageView.isHidden = true
        roundedView.isHidden = false
        checkmarkButton.isHidden = false
        promocodeLabel.isHidden = false
        promocodeDescriptionLabel.isHidden = false
        promocodeToolbar.dismiss()
        PromocodeActivator.post(code: promocode) { [weak self] in
            self?.promocodeDescriptionLabel.text = $0
        }
    }
    
   
}
