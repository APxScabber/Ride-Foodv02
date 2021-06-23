import UIKit

class PromotionListTableViewController: UITableViewController {

    private(set) var promotions = [Promotion]()
    
    var promotionType: PromotionsFetcher.PromotionType = .food { didSet {
        navigationItem.title = PromotionConstant.promotion + " " + promotionType.rawValue.localized.lowercased()
    }}
    
    @IBAction func dismiss() {
        navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        PromotionsFetcher.fetch(promotionType) { [weak self] result in
            self?.promotions = result
            self?.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return promotions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodPromotionCell", for: indexPath)
        if let promotionCell = cell as? PromotionTableViewCell {
            promotionCell.promotionLabel.text = promotions[indexPath.row].title
            promotionCell.fetchImageFrom(promotions[indexPath.row].imagesURL[1])
            promotionCell.resignationHandler = { [unowned self] in
                self.showPromotionViewAt(indexPath.row)
            }
            return promotionCell
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private let promotionView = PromotionDetail.initFromNib()
    
    private func showPromotionViewAt(_ index:Int) {
        if let window = UIApplication.shared.keyWindow {
           let currentPromotion = promotions[index]
            promotionView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: view.bounds.width, height: UIScreen.main.bounds.height)
            window.addSubview(promotionView)
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: PromotionConstant.durationForAppearingPromotionView, delay: 0.0, options: .curveLinear) {
               self.promotionView.frame.origin.y -= self.view.bounds.height
           }
            promotionView.headerLabel.text = currentPromotion.title
            ImageFetcher.fetch(currentPromotion.imagesURL[0]) { data in
                #warning("такого быть не должно, тестирую пока")
                self.promotionView.imageView.image = UIImage(data: data)
            }
        }


    }
    
}


