import UIKit

class SupportAddImagesViewController: UIViewController {
    
    //MARK: - Public API
    
    var text = ""
    var images = [UIImage]() { didSet {
        errorDescriptionLabel.isHidden = images.count < SupportConstant.imagesLimit
        addImagesButton.buttonState = images.count < SupportConstant.imagesLimit ? .active : .inActive
        addImagesButton.isUserInteractionEnabled = images.count < SupportConstant.imagesLimit
    }}
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var sendButton: RoundedButton! { didSet {
        sendButton.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 17)
    }}
    
    @IBOutlet weak var addImagesButton: SupportAddImageButton!
    
    @IBOutlet weak var addImageDescriptionLabel: UILabel! { didSet {
        addImageDescriptionLabel.font = UIFont.SFUIDisplayLight(size: 17)
    }}
    
    @IBOutlet weak var successLabel: UILabel! { didSet {
        successLabel.font = UIFont.SFUIDisplayLight(size: 17)
    }}
    
    @IBOutlet weak var goBackView: UIView! { didSet {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(done))
        goBackView.addGestureRecognizer(tapGesture)
    }}
    @IBOutlet weak var roundedView: RoundedView!
    @IBOutlet weak var errorDescriptionLabel: UILabel! { didSet {
        errorDescriptionLabel.font = UIFont.SFUIDisplayRegular(size: 12)
    }}
    
    
    
    //MARK: - IBActions
    @IBAction func addImage(_ sender: UIButton) {
        SupportActionSheet.showIn(self)
        SupportActionSheet.delegate = self
    }

    @IBAction func sendFeedback(_ sender: RoundedButton) {
        sendButton.setTitle(SupportConstant.done, for: .normal)
        addImagesButton.buttonState = .done
        addImageDescriptionLabel.text = SupportConstant.messageSent
        addImageDescriptionLabel.textColor = #colorLiteral(red: 0.2039215686, green: 0.7411764706, blue: 0.3490196078, alpha: 1)
        successLabel.isHidden = false
        roundedView.color = .clear
    }
    
    
    @objc
    private func done() {
        dismiss(animated: true)
    }
    
}

//MARK: - ImagePickerDelegate
extension SupportAddImagesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else { return }
        images.append(image)
        collectionView.reloadData()
        picker.dismiss(animated: true)
    }
    
}

//MARK: - UICollectionViewDataSourse and delegate

extension SupportAddImagesViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SupportCell", for: indexPath)
        if let supportCell = cell as? SupportCollectionViewCell {
            supportCell.imageView.image = images[indexPath.row]
            supportCell.completionHandler = { [unowned self] in
                self.removeImageAt(indexPath.row)
            }
            return supportCell
        }
        return cell
    }
    
    private func removeImageAt(_ index:Int) {
        images.remove(at: index)
        collectionView.reloadData()
    }
}

//MARK: - UICollectionViewFlowLayout

extension SupportAddImagesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 91, height: 91)
    }
    
}

//MARK: - SupportActionSheetDelegate

extension SupportAddImagesViewController: SupportActionSheetDelegate {
    
   func goToCamera() {
        ImagePicker.showWith(.camera, in: self)
    }
    
    func goToLibrary() {
        ImagePicker.showWith(.photoLibrary, in: self)
    }
}
