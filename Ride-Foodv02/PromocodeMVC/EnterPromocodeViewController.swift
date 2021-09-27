import UIKit

class EnterPromocodeViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var checkmarkButton: UIButton!
    @IBOutlet weak var doneButton: UIButton! { didSet {
        doneButton.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 17)
        doneButton.isUserInteractionEnabled = false
    }}
    @IBOutlet weak var roundedView: RoundedView! { didSet {
        roundedView.cornerRadius = 15.0
        roundedView.colorToFill = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
    }}
    @IBOutlet weak var promocodeLabel: UILabel! { didSet {
        promocodeLabel.font = UIFont.SFUIDisplaySemibold(size: 17)
        promocodeLabel.text = Localizable.Promocode.promocodeActivated.localized
    }}
    @IBOutlet weak var promocodeDescriptionLabel: UILabel! { didSet {
        promocodeDescriptionLabel.font = UIFont.SFUIDisplayLight(size: 17)
    }}
    @IBOutlet weak var imageView: UIImageView!
    private var promocodeToolbar = PromocodeToolbar.initFromNib()
    
    //MARK: - Action
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    //MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(showToolbarView(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        promocodeToolbar.delegate = self
        PromocodeActivator.delegate = self
        navigationItem.title = Localizable.Promocode.enterPromocode.localized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return }
        promocodeToolbar.frame = CGRect(x: 0, y: window.bounds.height, width: window.bounds.width, height: PromocodeConstant.toolbarHeight)
        promocodeToolbar.textField.becomeFirstResponder()
        window.addSubview(promocodeToolbar)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return }
        promocodeToolbar.frame = CGRect(x: 0, y: window.bounds.height, width: window.bounds.width, height: PromocodeConstant.toolbarHeight)
        promocodeToolbar.dismiss()
    }
    
    //MARK: - Toolbar
    @objc
    private func showToolbarView(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return }
        if let size = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            promocodeToolbar.frame.origin.y = window.frame.height - (size.height + PromocodeConstant.toolbarHeight )
        }
    }

}

//MARK: - PromocodeToolbar delegate

extension EnterPromocodeViewController: PromocodeToolbarDelegate {
    
    func activate(promocode: String) {
        PromocodeActivator.post(code: promocode)
        promocodeToolbar.spinner.startAnimating()
    }
    
   
}

//MARK: - PromocodeActivatorDelegate

extension EnterPromocodeViewController: PromocodeActivatorDelegate {
    
    func promocodeFailed(_ error: String) {
        promocodeToolbar.lineView.backgroundColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
        promocodeToolbar.errorLabel.isHidden = false
        promocodeToolbar.errorLabel.text = error
        promocodeToolbar.spinner.stopAnimating()
    }
    
    func promocodeActivated(_ description: String) {
        imageView.isHidden = true
        roundedView.isHidden = false
        checkmarkButton.isHidden = false
        promocodeLabel.isHidden = false
        promocodeDescriptionLabel.isHidden = false
        promocodeToolbar.dismiss()
        doneButton.setTitle(Localizable.Promocode.promocodeDone.localized, for: .normal)
        promocodeDescriptionLabel.text = description
        promocodeToolbar.spinner.stopAnimating()
        doneButton.isUserInteractionEnabled = true
    }
}

