import UIKit

class ImagePicker {
    
    static func showWith(_ type:UIImagePickerController.SourceType,in vc: UIViewController) {
        let ipc = UIImagePickerController()
        ipc.sourceType = type
        ipc.allowsEditing = true
        ipc.delegate = vc as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        vc.present(ipc, animated: true)
    }
    
}
