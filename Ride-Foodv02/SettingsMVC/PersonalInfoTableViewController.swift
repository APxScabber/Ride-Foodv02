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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = PersonalInfoConstant.personalInfo
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        toolBarView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: view.bounds.width, height: SettingsConstant.toolbarHeight)
        view.addSubview(toolBarView)
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
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= -100 {
            toolBarView.dismiss()
            view.backgroundColor = .white
            cells.forEach {
                $0.backgroundColor = .white
                $0.isUserInteractionEnabled = true
            }
        }
    }
    
    private func updateUI() {
        nameLabel.text = PersonalInfoConstant.nameQuestion
        emailLabel.text = PersonalInfoConstant.emailQuestion
    }
    
}


extension PersonalInfoTableViewController: ToolbarViewDelegate {
    
    func done() {
        
    }
}
