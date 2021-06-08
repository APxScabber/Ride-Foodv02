import UIKit

class SupportCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView! { didSet {
        imageView.roundedBy(15)
    }}
    
    @IBAction func remove(_ sender: UIButton) { completionHandler?() }
    
    var completionHandler: ( () -> () )?
    
}
