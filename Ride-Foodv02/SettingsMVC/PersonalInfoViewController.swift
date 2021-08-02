import UIKit

class PersonalInfoViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var phoneLabel: UILabel! { didSet {
        phoneLabel.font = UIFont.SFUIDisplayRegular(size: 15.0)
    }}
    @IBOutlet weak var nameLabel: UILabel! { didSet {
        nameLabel.font = UIFont.SFUIDisplayRegular(size: 12.0)
    }}
    @IBOutlet weak var emailLabel: UILabel! { didSet {
        emailLabel.font = UIFont.SFUIDisplayRegular(size: 12.0)
    }}
    
    @IBOutlet weak var nameChoserLabel: UILabel! { didSet {
        nameChoserLabel.font = UIFont.SFUIDisplayRegular(size: 15.0)
    }}
    @IBOutlet weak var emailChoserLabel: UILabel! { didSet {
        emailChoserLabel.font = UIFont.SFUIDisplayRegular(size: 15.0)
    }}
    
    @IBOutlet weak var privacyLabel: UILabel! { didSet {
        
    }}
    
    @IBOutlet weak var transparentView: UIView! { didSet {
        transparentView.isHidden = true
    }}

    
    private var toolBarView = ToolbarView.initFromNib()
    
    //MARK: - IBActions
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func enterName(_ sender: UIButton) {
        toolBarView.text = PersonalInfoConstant.nameQuestion
        activateToolbar()
        toolBarView.state = .name
    }
    
    @IBAction func enterEmail(_ sender: UIButton) {
        toolBarView.text = PersonalInfoConstant.emailQuestion
        activateToolbar()
        toolBarView.state = .email
    }
    
    //MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toolBarView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(showToolbarView(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = PersonalInfoConstant.personalInfo
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let window = UIApplication.shared.keyWindow {
            toolBarView.frame = CGRect(x: 0, y: window.bounds.height, width: view.bounds.width, height: SettingsConstant.toolbarHeight)
            window.addSubview(toolBarView)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        remove()
    }
    
        
    private func updateUI() {
        nameLabel.text = PersonalInfoConstant.name
        nameChoserLabel.text = PersonalInfoConstant.nameQuestion
        emailChoserLabel.text = PersonalInfoConstant.emailQuestion
        privacyLabel.attributedText = PersonalInfoConstant.privacyText
    }
    
        
    @objc
    private func showToolbarView(_ notification:NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let window = UIApplication.shared.keyWindow else { return }
        if let size = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            toolBarView.frame.origin.y = window.bounds.height - (size.height + SettingsConstant.toolbarHeight)
        }
    }

    private func activateToolbar() {
        toolBarView.textField.becomeFirstResponder()
        transparentView.isHidden = false
        transparentView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
}


extension PersonalInfoViewController: ToolbarViewDelegate {
    
    func done() {
        
        if toolBarView.state == .name {
            
        } else if toolBarView.state == .email {
            
        }
    }
    
    func remove() {
        toolBarView.dismiss()
        guard let window = UIApplication.shared.keyWindow else { return }
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: PersonalInfoConstant.durationForDisappearingToolbarView, delay: 0.0, options: .curveLinear) {
            self.toolBarView.frame.origin.y = window.bounds.height
        } completion: { if $0 == .end { self.transparentView.isHidden = true }
        }

    }
}
