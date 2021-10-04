import UIKit

//MARK: - Protocol

protocol SupportActionSheetDelegate: AnyObject {
    func goToCamera()
    func goToLibrary()
    func cancel()
}


class SupportActionSheetView: UIView {

    //MARK: - API
    
    weak var delegate: SupportActionSheetDelegate?
    
    //MARK: - Outlets
    
    @IBOutlet weak var mediaLibraryView: RoundedView! { didSet {
        mediaLibraryView.cornerRadius = 15.0
        mediaLibraryView.colorToFill = .white
    }}
    
    @IBOutlet weak var cancelButton: UIButton! { didSet {
        cancelButton.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 17.0)
        cancelButton.layer.cornerRadius = 15.0
    }}
    
    @IBOutlet weak var captureLabel: UILabel! { didSet {
        captureLabel.font = UIFont.SFUIDisplayRegular(size: 17)
    }}
    
    @IBOutlet weak var libraryLabel: UILabel! { didSet {
        libraryLabel.font = UIFont.SFUIDisplayRegular(size: 17)
    }}
    
    
    @IBOutlet weak var goToCameraView: UIView! { didSet {
        goToCameraView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToCamera)))
    }}
    
    @IBOutlet weak var goToLibraryView: UIView! { didSet {
        goToLibraryView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToLibrary)))

    }}
    
    
    //MARK: - Actions

    @IBAction func cancel(_ sender: UIButton) {
        delegate?.cancel()
    }
    
    @objc
    private func goToCamera() {
        delegate?.goToCamera()
    }
    
    @objc
    private func goToLibrary() {
        delegate?.goToLibrary()
    }
    
    //MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        captureLabel.text = Localizable.Support.capture.localized
        cancelButton.setTitle(Localizable.Support.cancel.localized, for: .normal)
        libraryLabel.text = Localizable.Support.library.localized

    }
    
}
