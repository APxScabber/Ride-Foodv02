import UIKit

class SupportMainViewController: UIViewController {

    //MARK: - Public API
    
    var text = "" { didSet { updateUI() }}
    
    //MARK: - Outlets
    @IBOutlet weak var textViewLabelDescription: UILabel! { didSet  {
        textViewLabelDescription.font = UIFont.SFUIDisplayLight(size: 17)
    }}

    
    @IBOutlet weak var nextButton: RoundedButton! { didSet {
        nextButton.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 17)
    }}
    @IBOutlet weak var roundedView: RoundedView! { didSet {
        roundedView.cornerRadius = 15.0
        roundedView.color = #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)
    }}
    @IBOutlet weak var distanceFromBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView! { didSet {
        textView.font = UIFont.SFUIDisplayLight(size: 17)
    }}
    //MARK: - IBActions
    @IBAction func dismiss(_ sender:UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        NotificationCenter.default.addObserver(self, selector: #selector(updateConstraintWith(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        navigationController?.navigationItem.title = "Служба поддержки"
    }
    
    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "supportAddImagesSegue",
           let destination = segue.destination as? SupportAddImagesViewController {
            destination.text = self.text
        }
    }
   
    
    //MARK: - UI changes
    private func updateUI() {
        nextButton.color = text.count < SupportConstant.minimumLeters ? UIColor.supportNextButtonInActiveColor : UIColor.SupportNextButtonActiveColor
        nextButton.isUserInteractionEnabled = text.count >= SupportConstant.minimumLeters
        textViewLabelDescription.isHidden = !text.isEmpty
    }

    @objc
    private func updateConstraintWith(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        if let size = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if distanceFromBottomConstraint.constant == SupportConstant.bottomConstraintValue {
            distanceFromBottomConstraint.constant += size.height
            } else { distanceFromBottomConstraint.constant = SupportConstant.bottomConstraintValue }
        }
        
    }
   
}

//MARK: - UITextViewDelegate
extension SupportMainViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        text = textView.text
    }
    
    
}
