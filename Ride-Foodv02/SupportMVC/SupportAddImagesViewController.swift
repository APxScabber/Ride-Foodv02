import UIKit

class SupportAddImagesViewController: UIViewController {
    
    //MARK: - Public API
    var text = ""
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var sendButton: RoundedButton! { didSet {
        sendButton.titleLabel?.font = UIFont(name: "SFUIDisplay-Regular", size: 17)
    }}
    
    @IBOutlet weak var addImagesButton: UIButton!
    
    @IBOutlet weak var addImageDescriptionLabel: UILabel! { didSet {
        addImageDescriptionLabel.font = UIFont(name: "SFUIDisplay-Light", size: 17)
    }}
    
    @IBOutlet weak var goBackView: UIView! { didSet {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(done))
        goBackView.addGestureRecognizer(tapGesture)
    }}
    
    //MARK: - IBActions
    @IBAction func addImage(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Снять фото или видео", style: .default, handler: { action in
            self.goToCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Медиатека", style: .default, handler: { action in
            self.goToLibrary()
        }))
        present(actionSheet, animated: true)
    }

    @IBAction func sendFeedback(_ sender: RoundedButton) {
        sendButton.setTitle("Отлично!", for: .normal)
        addImagesButton.setImage(UIImage(named: "DoneButton"), for: .normal)
    }
    
    @objc
    private func goToCamera() {
        
    }
    
    @objc
    private func goToLibrary() {
        
    }
    
    @objc
    private func done() {
        dismiss(animated: true)
    }
    
}
