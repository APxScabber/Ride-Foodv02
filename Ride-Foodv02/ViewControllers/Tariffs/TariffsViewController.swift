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
    @IBOutlet weak var tariffInfoText: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var orderTaxiButtonOutlet: UIButton!
    
    
    // MARK: - Properties
    
    var userID: String?
    
    let tariffsInteractor = TariffsInteractor()
    
    var tarrifsButtonArray: [UIButton] = []
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
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
            
            DispatchQueue.main.async {
                
                
                
                self?.carTypeLabel.text = tariffsData.cars
                
                if let image = self?.tariffsInteractor.getImage(from: tariffsData.icon) {
                    self?.carImage.image = image
                }
                
                self?.tariffInfoText.tariffsInfoStyle(text: tariffsData.description)
            }

            
            print("Тариф: \(tariffsData.name)")
            print("Автомобили: \(tariffsData.cars)")
            print("Описание: \(tariffsData.description)")
        }
    }
    

}
