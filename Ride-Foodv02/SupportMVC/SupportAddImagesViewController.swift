import UIKit

class SupportAddImagesViewController: UIViewController {
    
    //MARK: - Public API
    
    var text = ""
    private(set) var images = [UIImage]() { didSet {
        errorDescriptionLabel.isHidden = images.count < SupportConstant.imagesLimit
        addImagesButton.buttonState = images.count < SupportConstant.imagesLimit ? .active : .inActive
        addImagesButton.isUserInteractionEnabled = images.count < SupportConstant.imagesLimit
    }}
    
    //MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var sendButton: UIButton! { didSet {
        sendButton.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 17)
        sendButton.layer.cornerRadius = 15.0
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
    
    @IBOutlet weak var roundedView: RoundedView! { didSet {
        roundedView.color = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    }}
    @IBOutlet weak var barButton: UIBarButtonItem!
    
    private let actionSheetView = SupportActionSheetView.initFromNib()
    
    //MARK: - IBActions
    
    @IBAction func dismiss(_ sender:UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
        
    @IBAction func addImage(_ sender: UIButton) {
        enableUI(false)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: SupportConstant.actionSheetAnimationDuration, delay: 0, options: .curveLinear) {
            self.actionSheetView.frame.origin.y -= SupportConstant.actionSheetHeight
        }
    }

    @IBAction func sendFeedback(_ sender: UIButton) {
        if addImagesButton.buttonState != .done {
            addImagesButton.buttonState = .done
            barButton.isEnabled = false
            sendButton.setTitle(Localizable.Support.supportDone.localized, for: .normal)
            addImageDescriptionLabel.text = Localizable.Support.messageSent.localized
            addImageDescriptionLabel.textColor = #colorLiteral(red: 0.2039215686, green: 0.7411764706, blue: 0.3490196078, alpha: 1)
            successLabel.isHidden = false
            successLabel.text = Localizable.Support.responceDesc.localized
            roundedView.color = .clear
            collectionView.removeFromSuperview()
        } else {
            performSegue(withIdentifier: "unwindSegueFromSupport", sender: sender)
            dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: - ViewController lifecycle
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if addImagesButton.buttonState != .done {
            navigationItem.title = Localizable.Menu.support.localized
            sendButton.setTitle(Localizable.Support.send.localized, for: .normal)
            addImageDescriptionLabel.text = Localizable.Support.addImageDesc.localized
            errorDescriptionLabel.text = Localizable.Support.photoLimitDesc.localized
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        actionSheetView.frame = CGRect(x: 0, y: view.bounds.maxY, width: view.bounds.width, height: SupportConstant.actionSheetHeight)
        actionSheetView.delegate = self
        view.addSubview(actionSheetView)
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
        showWith(.camera)
        cancel()
    }
    
    func goToLibrary() {
        showWith(.photoLibrary)
        cancel()
    }
    
    func cancel() {
        enableUI(true)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: SupportConstant.actionSheetAnimationDuration, delay: 0, options: .curveLinear) {
            self.actionSheetView.frame.origin.y += SupportConstant.actionSheetHeight
        }
    }
    
    private func showWith(_ type:UIImagePickerController.SourceType) {
        let ipc = UIImagePickerController()
        ipc.sourceType = type
        ipc.allowsEditing = true
        ipc.delegate = self
        present(ipc, animated: true)
    }
   
}
