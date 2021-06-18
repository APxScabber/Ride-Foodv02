import UIKit

protocol SupportActionSheetDelegate: AnyObject {
    func goToCamera()
    func goToLibrary()
    func cancel()
}

@IBDesignable
class SupportRoundedView: UIView {
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 15.0)
        UIColor.white.setFill()
        path.fill()
    }
    
}

class SupportActionSheetView: UIView {

    weak var delegate: SupportActionSheetDelegate?
    
    //MARK: - Outlets
    @IBOutlet weak var captureLabel: UILabel! { didSet {
        captureLabel.font = UIFont.SFUIDisplayRegular(size: 17)
    }}
    
    @IBOutlet weak var libraryLabel: UILabel! { didSet {
        libraryLabel.font = UIFont.SFUIDisplayRegular(size: 17)
    }}
    
    @IBOutlet weak var cancelLabel: UILabel! { didSet {
        cancelLabel.font = UIFont.SFUIDisplayRegular(size: 17)
    }}
    
    @IBOutlet weak var goToCameraView: UIView! { didSet {
        goToCameraView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToCamera)))
    }}
    
    @IBOutlet weak var goToLibraryView: UIView! { didSet {
        goToLibraryView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToLibrary)))

    }}
    
    @IBOutlet weak var cancelView: UIView! { didSet {
        cancelView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancel)))

    }}
    
    //MARK: - Initialization

    class func initFromNib() -> SupportActionSheetView {
        return Bundle(for: SupportActionSheetView.self).loadNibNamed(String(describing: "SupportActionSheetView"), owner: nil, options: nil)!.first as! SupportActionSheetView
    }
    
    //MARK: - Actions

    @objc
    private func cancel() {
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        captureLabel.text = SupportConstant.capture
        cancelLabel.text = SupportConstant.cancel
        libraryLabel.text = SupportConstant.library

    }
    
}
