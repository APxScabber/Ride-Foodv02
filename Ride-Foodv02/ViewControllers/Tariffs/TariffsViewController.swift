//
//  TariffsViewController.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 15.06.2021.
//

import UIKit

class TariffsViewController: UIViewController {
    
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
    

    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSmallTariffButtons()
        setupCarsTypeLabel()
        setupTarifInfoLabels()
        
        
    }
    
    // MARK: - Methods
    
    private func setupSmallTariffButtons() {
        
        let tarrifsButtonArray = [standartButtonOutlet, premiumButtonOutlet, businessButtonOutlet]
        for button in tarrifsButtonArray {
            guard let button = button else { return }
            button.tariffsSmallStyle()
        }
        standartButtonOutlet.setTitle("Стандарт", for: .normal)
        premiumButtonOutlet.setTitle("Премиум", for: .normal)
        businessButtonOutlet.setTitle("Бизнес", for: .normal)
    }
    
    private func setupCarsTypeLabel() {
        let carsTypeLabelArray = [carLabel, carTypeLabel]
        for label in carsTypeLabelArray {
            guard let label = label else { return }
            label.font = UIFont(name: TextFont.main.rawValue, size: TariffsFontSize.small.rawValue)
        }
        carLabel.textColor = TariffsColors.grayLabelColor.value
        carLabel.text = "Автомобили:"
        carTypeLabel.textColor = TariffsColors.black.value
        carTypeLabel.text = "Mercedes C-klasse, Audi A6, BMW 5"
    }
    
    private func setupTarifInfoLabels() {
        tarrifInfoHeading.font = UIFont(name: TextFont.main.rawValue, size: TariffsFontSize.big.rawValue)
        tarrifInfoHeading.textColor = TariffsColors.black.value
        tarrifInfoHeading.text = "О тарифах"
        
        tariffInfoText.tariffsInfoStyle()
    }
    

}
