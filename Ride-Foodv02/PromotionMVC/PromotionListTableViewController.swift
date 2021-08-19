import UIKit

class PromotionListTableViewController: UITableViewController {

    private(set) var promotions = [PromotionModel]()
    private let promotionView = PromotionDetail.initFromNib()

    var promotionType: PromotionsFetcher.PromotionType = .food { didSet {
        navigationItem.title = Localizable.Promotion.promotion.localized + " " + promotionType.rawValue.localized.lowercased()
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
            promotionCell.fetchImageFrom(promotions[indexPath.row].media[0].url)
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
    
    
    private func showPromotionViewAt(_ index:Int) {
        if let window = UIApplication.shared.keyWindow {
           let currentPromotion = promotions[index]
            promotionView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: view.bounds.width, height: UIScreen.main.bounds.height)
            window.addSubview(promotionView)
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0.0, options: .curveLinear) {
               self.promotionView.frame.origin.y = 0
           }
            promotionView.headerLabel.text = currentPromotion.title
            ImageFetcher.fetch(currentPromotion.media[0].url) { data in
                self.promotionView.imageView.image = UIImage(data: data)
            }
            PromotionsFetcher.getPromotionDescriptionWith(id: promotions[index].id) { [weak self] in
                self?.promotionView.descriptionLabel.text = $0
            }
        }


    }
    
}


