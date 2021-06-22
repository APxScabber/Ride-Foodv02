//
//  TariffsViewController.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 15.06.2021.
//

import UIKit

class TariffsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var topLineLabel: UILabel!
    @IBOutlet weak var standartButtonOutlet: UIButton!
    @IBOutlet weak var premiumButtonOutlet: UIButton!
    @IBOutlet weak var businessButtonOutlet: UIButton!
    @IBOutlet weak var carLabel: UILabel!
    @IBOutlet weak var carTypeLabel: UILabel!
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var tarrifInfoHeading: UILabel!
    @IBOutlet weak var tariffInfoText: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var orderTaxiButtonOutlet: UIButton!
    
    
    // MARK: - Properties
    
    var userID: String?
    var tarrifsButtonArray: [UIButton] = []
    var indexVC = 0
  
    let tariffsInteractor = TariffsInteractor()

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
       
        
        tarrifsButtonArray = [standartButtonOutlet, premiumButtonOutlet, businessButtonOutlet]
        
        tariffsInteractor.getUserID()
        userID = tariffsInteractor.userID
        
        setupSmallTariffButtons()
        setupCarsTypeLabel()
        setupTarifInfoLabels()
        
        getTariffsData()
    }
    
    // MARK: - Setups Methods
    
    private func setupSmallTariffButtons() {
        
        let tarrifsButtonArray = [standartButtonOutlet, premiumButtonOutlet, businessButtonOutlet]
        for button in tarrifsButtonArray {
            guard let button = button else { return }
            button.tariffsSmallStyle()
            button.backgroundColor = TariffsColors.grayButtonColor.value
        }
        standartButtonOutlet.setTitle("Стандарт", for: .normal)
        premiumButtonOutlet.setTitle("Премиум", for: .normal)
        businessButtonOutlet.setTitle("Бизнес", for: .normal)
    }
    
    private func setupCarsTypeLabel() {
        let carsTypeLabelArray = [carLabel, carTypeLabel]
        for label in carsTypeLabelArray {
            guard let label = label else { return }
            label.font = UIFont(name: MainTextFont.main.rawValue, size: TariffsFontSize.small.rawValue)
        }
        carLabel.textColor = TariffsColors.grayLabelColor.value
        carLabel.text = "Автомобили:"
        carTypeLabel.textColor = TariffsColors.black.value
        carTypeLabel.text = ""
    }
    
    private func setupTarifInfoLabels() {
        tarrifInfoHeading.font = UIFont(name: MainTextFont.main.rawValue, size: TariffsFontSize.big.rawValue)
        tarrifInfoHeading.textColor = TariffsColors.black.value
        tarrifInfoHeading.text = "О тарифах"
        tariffInfoText.text = ""
    }
    
    // MARK: - Methods
    
    func getTariffsData() {
        
        guard let id = userID else { return }
        
        tariffsInteractor.loadTariffs(userID: id) { [weak self] (dataModel) in
            guard let tariffsData = dataModel else { return }
            
            DispatchQueue.main.async { [weak self] in
                
                guard let indexVC = self?.indexVC else { return }
                
                self?.carTypeLabel.text = tariffsData[indexVC].cars
                
                if let image = self?.tariffsInteractor.getImage(from: tariffsData[indexVC].icon) {
                    self?.carImage.image = image
                }
                
                self?.tariffInfoText.tariffsInfoStyle(text: tariffsData[indexVC].description)
            }
        }
    }
}

extension TariffsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) //as! TariffsCollectionViewCell
        
//        cell.cellImageView.image = UIImage(named: "checkBtnOn")
//        cell.cellLabel.text = "Allways have baby seat"
        
        return cell
    }
    

    
    
}


extension TariffsViewController: UICollectionViewDelegateFlowLayout {

    private func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//
//        let linespacing: CGFloat = 5
//        let numberOfCell: CGFloat = 3   //you need to give a type as CGFloat
//        let cellWidth = UIScreen.main.bounds.size.width / numberOfCell
//        return CGSize(width: cellWidth - linespacing, height: cellWidth - linespacing)
        
        let size = CGSize(width: 30, height: 30)
        print(size)
        
        return size
    }
}
