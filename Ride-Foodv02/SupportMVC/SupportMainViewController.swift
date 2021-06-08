import UIKit

class SupportMainViewController: UIViewController {

    //MARK: - Public API
    
    var text = "" { didSet { updateUI() }}
    
    @IBOutlet weak var supportLabel: UILabel! { didSet {
        supportLabel.font = UIFont(name: "SFUIDisplay-Semibold", size: 15)
    }}

    @IBOutlet weak var textViewLabelDescription: UILabel! { didSet  {
        textViewLabelDescription.font = UIFont(name: "SFUIDisplay-Light", size: 17)
    }}
    
    @IBOutlet weak var goBackView: UIView! { didSet {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismiss(_:)))
        goBackView.addGestureRecognizer(tapGesture)
    }}
    
    @IBOutlet weak var nextButton: RoundedButton! { didSet {
        nextButton.titleLabel?.font = UIFont(name: "SFUIDisplay-Regular", size: 17)
    }}
    
    @IBOutlet weak var distanceFromBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView! { didSet {
        textView.font = UIFont(name: "SFUIDisplay-Light", size: 17)
    }}
    
    //MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        NotificationCenter.default.addObserver(self, selector: #selector(updateConstraintWith(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
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
        nextButton.color = text.count < 3 ? UIColor(red: 208/255, green: 208/255, blue: 208/255, alpha: 1) : UIColor(red: 61/255, green: 59/255, blue: 255/255, alpha: 1)
        nextButton.isUserInteractionEnabled = text.count >= 3
        textViewLabelDescription.isHidden = !text.isEmpty
    }

    @objc
    private func updateConstraintWith(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        if let size = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if distanceFromBottomConstraint.constant == 25 {
            distanceFromBottomConstraint.constant += size.height
            } else { distanceFromBottomConstraint.constant = 25 }
        }
        
    }
    
    //MARK: - Helper
    @objc
    private func dismiss(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            //go back in the future
            print("go back works")
        }
    }
}


extension SupportMainViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        text = textView.text
    }
    
    
}
