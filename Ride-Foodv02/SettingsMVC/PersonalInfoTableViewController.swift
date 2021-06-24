import UIKit

class PersonalInfoTableViewController: UITableViewController {
    
    
    @IBOutlet var cells: [UITableViewCell]!
    @IBOutlet weak var nameLabel: SettingsMainLabel! 
    @IBOutlet weak var emailLabel: SettingsMainLabel!
    private var toolBarView = ToolbarView.initFromNib() { didSet {
        toolBarView.delegate = self
    }}
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 { return SettingsHeaderView.createWith(SettingsConstant.name, in: self.view)}
        if section == 2 { return SettingsHeaderView.createWith(SettingsConstant.email, in: self.view)}
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        view.backgroundColor = .SettingsBackgroundColor
        cells.forEach {
            $0.backgroundColor = .SettingsBackgroundColor
            $0.isUserInteractionEnabled = false
        }
        toolBarView.textField.becomeFirstResponder()
    }
    
    
    private func updateUI() {
        nameLabel.text = PersonalInfoConstant.nameQuestion
        emailLabel.text = PersonalInfoConstant.emailQuestion
    }
    
    @objc
    private func showToolbarView(_ notification:NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        if let size = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            toolBarView.frame.origin.y -= (size.height + SettingsConstant.toolbarHeight)
        }
    }
    
}


extension PersonalInfoTableViewController: ToolbarViewDelegate {
    
    func done() {
        
    }
}
