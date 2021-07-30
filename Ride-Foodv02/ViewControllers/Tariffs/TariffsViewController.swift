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
    var linespacing: CGFloat = 5
    
    var advantagesIconsArray = [UIImage]()
    var advantagesTitlesArray = [String]()

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
        setupTaxiOrderButton()
        
        getTariffsData()
    }
    
    // MARK: - Setups Methods
    
    //Задаем параметры внешнего вида указателей тарифного плана
    private func setupSmallTariffButtons() {
        
        let tarrifsButtonArray = [standartButtonOutlet, premiumButtonOutlet, businessButtonOutlet]
        for button in tarrifsButtonArray {
            guard let button = button else { return }
            button.tariffsSmallStyle()
            button.backgroundColor = TariffsColors.grayButtonColor.value
        }
        standartButtonOutlet.setTitle(TariffsViewText.standartLabel.text(), for: .normal)
        premiumButtonOutlet.setTitle(TariffsViewText.premiumLabel.text(), for: .normal)
        businessButtonOutlet.setTitle(TariffsViewText.businessLabel.text(), for: .normal)
    }
    
    //Задаем параметры внешнего вида лейбла с перечнем Автомобилей
    private func setupCarsTypeLabel() {
        let carsTypeLabelArray = [carLabel, carTypeLabel]
        for label in carsTypeLabelArray {
            guard let label = label else { return }
            label.font = UIFont(name: MainTextFont.main.rawValue, size: TariffsFontSize.small.rawValue)
        }
        carLabel.textColor = TariffsColors.grayLabelColor.value
        carLabel.text = TariffsViewText.carLabel.text()
        carTypeLabel.textColor = TariffsColors.black.value
        carTypeLabel.text = TariffsViewText.emptyText.text()
    }
    
    //Задаем параметры внешнего вида информационного поля О Тарифе
    private func setupTarifInfoLabels() {
        tarrifInfoHeading.font = UIFont(name: MainTextFont.main.rawValue, size: TariffsFontSize.big.rawValue)
        tarrifInfoHeading.textColor = TariffsColors.black.value
        tarrifInfoHeading.text = TariffsViewText.aboutTariffs.text()
        tariffInfoText.text = TariffsViewText.emptyText.text()
    }
    
    //Задаем внешний вид кнопки Заказать такси
    private func setupTaxiOrderButton() {
        
        orderTaxiButtonOutlet.style()
        orderTaxiButtonOutlet.backgroundColor = TariffsColors.blueColor.value
        orderTaxiButtonOutlet.setTitle(TariffsViewText.taxiOrderButton.text(), for: .normal)
    }
    
    // MARK: - Methods
    
    //Размещаем полученные данные с сервера в нужные места
    func getTariffsData() {
        
        guard let id = userID else { return }
        
        tariffsInteractor.loadTariffs(userID: id) { [weak self] (dataModel) in
            guard let tariffsData = dataModel else { return }
            
            //DispatchQueue.main.async { [weak self] in
            
            guard let indexVC = self?.indexVC else { return }
            
            //self?.tariffsInteractor.getAdvantagesDatas(model: tariffsData[indexVC].advantages)
            
            let advantagesModel = tariffsData[indexVC].advantages
            //let advantages = CacheImageManager.shared.getAdvantagesDatas(model: advantagesModel)
            
            CacheImageManager.shared.getAdvantagesDatas(model: advantagesModel) { images, titles in
                self?.advantagesIconsArray = images
                self?.advantagesTitlesArray = titles
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }

            CacheImageManager.shared.cacheImage(from: tariffsData[indexVC].icon, completion: { image in
                DispatchQueue.main.async {
                    self?.carImage.image = image
                }
            })
            
            DispatchQueue.main.async {
                self?.tariffInfoText.tariffsInfoStyle(text: tariffsData[indexVC].description)
                self?.carTypeLabel.text = tariffsData[indexVC].cars
            }
        }
    }

    //Задаем цветовое оформление согласно выбранному тарифу
    func setTariffsColor(for cell: TariffsCollectionViewCell) {
        switch indexVC {
        case 0:
            cell.cellImageButton.tintColor = TariffsColors.standartColor.value
            topLineLabel.backgroundColor = TariffsColors.standartColor.value
            standartButtonOutlet.backgroundColor = TariffsColors.standartColor.value
        case 1:
            cell.cellImageButton.tintColor = TariffsColors.premiumColor.value
            topLineLabel.backgroundColor = TariffsColors.premiumColor.value
            premiumButtonOutlet.backgroundColor = TariffsColors.premiumColor.value
        default:
            cell.cellImageButton.tintColor = TariffsColors.businessColor.value
            topLineLabel.backgroundColor = TariffsColors.businessColor.value
            businessButtonOutlet.backgroundColor = TariffsColors.businessColor.value
        }
    }
}
