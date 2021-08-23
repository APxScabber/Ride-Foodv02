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
    
    @IBOutlet weak var privacyLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var transparentView: UIView! { didSet {
        transparentView.isHidden = true
    }}
    @IBOutlet weak var rowHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topOffsetConstraint: NSLayoutConstraint!
    
    private var toolBarView = ToolbarView.initFromNib()
    
    //MARK: - IBActions
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func enterName(_ sender: UIButton) {
        yOffset = sender.convert(sender.frame.origin, to: scrollView).y + sender.bounds.height
        toolBarView.text = Localizable.PersonalInfo.nameQuestion.localized
        activateToolbar()
        toolBarView.state = .name
    }
    
    @IBAction func enterEmail(_ sender: UIButton) {
        yOffset = sender.convert(sender.frame.origin, to: scrollView).y + sender.bounds.height
        toolBarView.text = Localizable.PersonalInfo.emailQuestion.localized
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
        navigationItem.title = Localizable.PersonalInfo.personalInfo.localized
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        toolBarView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: PersonalInfoConstant.toolbarHeight)
        view.addSubview(toolBarView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        remove()
    }
    
        
    private func updateUI() {
        nameLabel.text = Localizable.PersonalInfo.name.localized
        nameChoserLabel.text = Localizable.PersonalInfo.nameQuestion.localized
        emailChoserLabel.text = Localizable.PersonalInfo.emailQuestion.localized
        privacyLabel.attributedText = PersonalInfoConstant.privacyText
        CoreDataManager.shared.fetchCoreData { [weak self] result in
        switch result {
            case .success(let model):
                let userData = model.first
                if userData?.name != nil {
                    self?.nameChoserLabel.text = userData?.name
                    self?.nameChoserLabel.textColor = .black
                }
                if userData?.email != nil {
                    self?.emailChoserLabel.text = userData?.email
                    self?.emailChoserLabel.textColor = .black
                }
        default: break
            }
        }
    }
    
    private var yOffset: CGFloat = 0.0
    
    @objc
    private func showToolbarView(_ notification:NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        if let size = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            toolBarView.frame.origin.y = view.bounds.height - (size.height + PersonalInfoConstant.toolbarHeight)
            if toolBarView.frame.origin.y < yOffset {
                moveScrollViewYOffset(at: yOffset - toolBarView.frame.origin.y + rowHeightConstraint.constant + topOffsetConstraint.constant)
            }
        }
    }

    private func activateToolbar() {
        toolBarView.textField.becomeFirstResponder()
        transparentView.isHidden = false
        transparentView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    private func moveScrollViewYOffset(at: CGFloat) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: PersonalInfoConstant.durationForAppearingToolbarView, delay: 0, options: .curveLinear) {
            self.scrollView.contentOffset.y = at
        } completion: {  if $0 == .end { }
        }
    }
    
}


extension PersonalInfoViewController: ToolbarViewDelegate {
    
    func done() {
        
        CoreDataManager.shared.fetchCoreData { [weak self] result in
        switch result {
            case .success(let model):
                let userData = model.first
                if self?.toolBarView.state == .name {
                    userData?.name = self?.toolBarView.textField.text
                } else if self?.toolBarView.state == .email {
                    userData?.email = self?.toolBarView.textField.text
                }
                CoreDataManager.shared.saveContext()
                self?.updateUI()
                self?.remove()
        default: break
            }
        }
        
    }
    
    func remove() {
        toolBarView.dismiss()
        moveScrollViewYOffset(at: 0)
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return }
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: PersonalInfoConstant.durationForAppearingToolbarView, delay: 0.0, options: .curveLinear) {
            self.toolBarView.frame.origin.y = window.bounds.height
        } completion: { if $0 == .end { self.transparentView.isHidden = true }
        }

    }
}
