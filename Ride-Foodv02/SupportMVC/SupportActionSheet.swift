import UIKit

protocol SupportActionSheetDelegate: AnyObject {
    func goToCamera()
    func goToLibrary()
}

class SupportActionSheet {
    
    static weak var delegate: SupportActionSheetDelegate?
    
    static func showIn(_ vc:UIViewController) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: SupportConstant.cancel, style: .cancel))
        actionSheet.addAction(UIAlertAction(title: SupportConstant.capture, style: .default, handler: { action in
            delegate?.goToCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: SupportConstant.library, style: .default, handler: { action in
            delegate?.goToLibrary()
        }))
        vc.present(actionSheet, animated: true)
    }
    
}
