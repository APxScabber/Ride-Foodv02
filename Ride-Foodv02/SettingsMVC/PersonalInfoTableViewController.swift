import UIKit

class PersonalInfoTableViewController: UITableViewController {
    
    
    @IBOutlet var cells: [UITableViewCell]!
    private var toolBarView = ToolbarView.initFromNib() { didSet {
        toolBarView.delegate = self
    }}
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(showToolbarView(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        navigationController?.navigationItem.title = "Персональные данные"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        toolBarView.frame = CGRect(x: 0, y: view.bounds.maxY, width: view.bounds.width, height: 152)
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
        cells.forEach { $0.backgroundColor = .SettingsBackgroundColor }
        toolBarView.textField.becomeFirstResponder()
    }
    
    @objc
    private func showToolbarView(_ notification:NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        if let size = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            toolBarView.frame.origin.y -= 400
        }
    }
}


extension PersonalInfoTableViewController: ToolbarViewDelegate {
    
    func done() {
        
    }
}
