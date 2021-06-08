import UIKit

class SupportAddImagesViewController: UIViewController {
    
    //MARK: - Public API
    var text = ""
    var images = [UIImage]() { didSet {
        errorDescriptionLabel.isHidden = images.count < 3
        addImagesButton.setImage(UIImage(named: images.count < 3 ? "Plus" : "RemoveButton"), for: .normal)
        addImagesButton.isUserInteractionEnabled = images.count < 3
    }}
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var sendButton: RoundedButton! { didSet {
        sendButton.titleLabel?.font = UIFont(name: "SFUIDisplay-Regular", size: 17)
    }}
    
    @IBOutlet weak var addImagesButton: UIButton!
    
    @IBOutlet weak var addImageDescriptionLabel: UILabel! { didSet {
        addImageDescriptionLabel.font = UIFont(name: "SFUIDisplay-Light", size: 17)
    }}
    
    @IBOutlet weak var successLabel: UILabel! { didSet {
        successLabel.font = UIFont(name: "SFUIDisplay-Light", size: 17)
    }}
    
    @IBOutlet weak var goBackView: UIView! { didSet {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(done))
        goBackView.addGestureRecognizer(tapGesture)
    }}
    @IBOutlet weak var errorDescriptionLabel: UILabel! { didSet {
        errorDescriptionLabel.font = UIFont(name: "SFUIDisplay-Regular", size: 12)
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
        addImagesButton.isUserInteractionEnabled = false
        addImageDescriptionLabel.text = "Обращение отправлено"
        addImageDescriptionLabel.textColor = #colorLiteral(red: 0.2039215686, green: 0.7411764706, blue: 0.3490196078, alpha: 1)
        successLabel.isHidden = false
    }
    
    @objc
    private func goToCamera() {
        ImagePicker.showWith(.camera, in: self)
    }
    
    @objc
    private func goToLibrary() {
        ImagePicker.showWith(.photoLibrary, in: self)
    }
    
    @objc
    private func done() {
        dismiss(animated: true)
    }
    
}


extension SupportAddImagesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else { return }
        images.append(image)
        collectionView.reloadData()
        picker.dismiss(animated: true)
    }
    
}


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


extension SupportAddImagesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 91, height: 91)
    }
    
}
