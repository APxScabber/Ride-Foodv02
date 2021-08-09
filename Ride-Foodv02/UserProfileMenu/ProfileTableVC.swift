import UIKit

protocol AddPhoneProtocolDelegate: AnyObject {
    func add(_ newPhone:String)
}

class ProfileTableVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK: - API
    
    //temp because no coreData yet
    var phones = [String]()
    
    //MARK: - Outlets
    
    @IBOutlet weak var userProfileLabel: UILabel! { didSet {
        userProfileLabel.font = UIFont.SFUIDisplaySemibold(size: 26.0)
        userProfileLabel.text = ProfileConstant.userProfile
    }}
   
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var logoutButton: UIButton! { didSet {
        logoutButton.titleLabel?.font = UIFont.SFUIDisplayLight(size: 15.0)
        logoutButton.setTitle(ProfileConstant.logout, for: .normal)
    }}
    @IBOutlet weak var transparentView: UIView! { didSet {
        transparentView.isHidden = true
    }}
    
    private let phoneChooserView = PhoneChooserView.initFromNib()
    private let enterPhoneView = EnterPhoneView.initFromNib()
    
    //MARK: - IBAction
    
    @IBAction func logout(_ sender: UIButton) {
        
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    //MARK: - Viewcontroller lifecycle
 
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneChooserView.delegate = self
        enterPhoneView.delegate = self
        view.addSubview(phoneChooserView)
        view.addSubview(enterPhoneView)
        NotificationCenter.default.addObserver(self, selector: #selector(showEnterPhoneView(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        phoneChooserView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: ProfileConstant.phoneChooserViewHeight)
        enterPhoneView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: ProfileConstant.enterPhoneViewHeight)
        phoneChooserView.isHidden = false
        enterPhoneView.isHidden = false
    }
    
    //MARK: - TableView Datasourse
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? max(2,phones.count + 1) : 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath)
        
        if let profileCell = cell as? ProfileTableViewCell {
            if indexPath.section == 0 {
                if phones.isEmpty  {
                    if indexPath.row == 0 {
                        profileCell.label.text = ProfileConstant.enterPhone
                        profileCell.customImageView.image = #imageLiteral(resourceName: "Contact")
                    } else {
                        profileCell.label.text = ProfileConstant.myAddresses
                    }
                } else {
                    if indexPath.row == 0 {
                        profileCell.mainLabel.isHidden = false  
                    }
                    if indexPath.row == phones.count {
                        profileCell.label.text = ProfileConstant.myAddresses
                    } else {
                        profileCell.label.text = phones[indexPath.row]
                        profileCell.customImageView.image = #imageLiteral(resourceName: "Contact")
                    }
                }
            } else {
                profileCell.customImageView.image = nil
                profileCell.label.text = ProfileConstant.data[indexPath.row]
                if indexPath == IndexPath(row: 2, section: 1) { //last row
                    profileCell.customImageView.image = #imageLiteral(resourceName: "one")
                }
            }
            return profileCell
        }
        return cell
    }
    
    
    //MARK: - TableView Delegate
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 && indexPath.row != max(1,phones.count)  {
            showAddPhoneView()
        }
    }
    
    
    
    //MARK: - Add phone
    
    private func showAddPhoneView() {
        transparentView.isHidden = false
        transparentView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        tableView.isUserInteractionEnabled = false
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: ProfileConstant.durationForAppearingPhoneChooserView, delay: 0.0, options: .curveLinear) {
            self.phoneChooserView.frame.origin.y = self.view.bounds.height - ProfileConstant.phoneChooserViewHeight
        } completion: { if $0 == .end {}
            
        }

    }
    
    @objc
    private func showEnterPhoneView(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let window = UIApplication.shared.keyWindow else { return }
        if let size = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            enterPhoneView.frame.origin.y = window.frame.height - (size.height + ProfileConstant.enterPhoneViewHeight )
        }
    }
    
}


//MARK: - PhoneChooserDelegate

extension ProfileTableVC: PhoneChooserViewDelegate {
    
    func dismiss() {
        transparentView.isHidden = true
        transparentView.backgroundColor = .clear
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: ProfileConstant.durationForAppearingPhoneChooserView, delay: 0.0, options: .curveLinear) {
            self.phoneChooserView.frame.origin.y = self.view.bounds.height
        } completion: { if $0 == .end {
            self.tableView.isUserInteractionEnabled = true
        }
            
        }
    }
    
    func add() {
        enterPhoneView.textField.becomeFirstResponder()
    }
}


//MARK: - EnterPhoneViewDelegate

extension ProfileTableVC: EnterPhoneViewDelegate {
    
    func add(_ newPhone: String) {
        phones.append(newPhone)
        tableView.reloadData()
        dismiss()
        close()
    }
    
    func change(_ newPhone: String) {
        
    }
    
    func close() {
        enterPhoneView.textField.resignFirstResponder()
        enterPhoneView.textField.text = ""
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: ProfileConstant.durationForAppearingEnterPhoneView, delay: 0, options: .curveLinear) {
            self.enterPhoneView.frame.origin.y = self.view.bounds.height
        } completion: {  if $0 == .end {}
        }

    }
}
