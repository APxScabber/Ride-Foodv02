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
    @IBOutlet weak var errorDescriptionLabel: UILabel! { didSet {
        errorDescriptionLabel.font = UIFont.SFUIDisplayRegular(size: 12)
    }}
    @IBOutlet weak var successLabel: UILabel! { didSet {
        successLabel.font = UIFont.SFUIDisplayLight(size: 17)
    }}
    
    @IBOutlet weak var roundedView: RoundedView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    private let actionSheetView = SupportActionSheetView.initFromNib()
    
    //MARK: - IBActions
    @IBAction func dismiss(_ sender:UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        actionSheetView.frame = CGRect(x: 0, y: view.bounds.maxY, width: view.bounds.width, height: SupportConstant.actionSheetHeight)
        actionSheetView.delegate = self
        view.addSubview(actionSheetView)
    }
    
    //MARK: - IBActions
    @IBAction func addImage(_ sender: UIButton) {
        enableUI(false)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: SupportConstant.actionSheetAnimationDuration, delay: 0, options: .curveLinear) {
            self.actionSheetView.frame.origin.y -= SupportConstant.actionSheetHeight
        }
    }

    @IBAction func sendFeedback(_ sender: RoundedButton) {
        if addImagesButton.buttonState != .done {
            sendButton.setTitle(SupportConstant.done, for: .normal)
            addImagesButton.buttonState = .done
            addImageDescriptionLabel.text = SupportConstant.messageSent
            addImageDescriptionLabel.textColor = #colorLiteral(red: 0.2039215686, green: 0.7411764706, blue: 0.3490196078, alpha: 1)
            successLabel.isHidden = false
            roundedView.color = .clear
            collectionView.removeFromSuperview()
        } else {
            //go back to main? screen or something
        }
    }
    
    //MARK: - EnableUI
    
    private func enableUI(_ yes:Bool) {
        view.backgroundColor = yes ? .white : UIColor.SupportBackgroundColor
        addImagesButton.isUserInteractionEnabled = yes
        sendButton.isUserInteractionEnabled = yes
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
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
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
        cancel()
    }
    
    func goToLibrary() {
        ImagePicker.showWith(.photoLibrary, in: self)
        cancel()
    }
    
    func cancel() {
        enableUI(true)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: SupportConstant.actionSheetAnimationDuration, delay: 0, options: .curveLinear) {
            self.actionSheetView.frame.origin.y += SupportConstant.actionSheetHeight
        }
    }
    
    
   
}
