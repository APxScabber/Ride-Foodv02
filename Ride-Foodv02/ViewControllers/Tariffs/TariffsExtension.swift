//
//  TariffsExtension.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 18.06.2021.
//

import Foundation
import UIKit

extension TariffsViewController: UICollectionViewDataSource {
    
    //Задаем количество ячеек в поле дополнительных опций тарифа
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    //Заполняем ячейки данными
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TariffsCollectionViewCell
        
        cell.cellLabel.text = ""
        let advantagesIconsArray = tariffsInteractor.advantagesIconsArray
        let advantagesTitlesArray = tariffsInteractor.advantagesTitlesArray
        
        if !advantagesIconsArray.isEmpty && !advantagesTitlesArray.isEmpty {
            
            setTariffsColor(for: cell)
            
            cell.cellImageButton.setImage(advantagesIconsArray[indexPath.row], for: .normal)
            //cell.cellImageView.image = advantagesIconsArray[indexPath.row]
            cell.cellLabel.text = advantagesTitlesArray[indexPath.row]
        }
        return cell
    }
}

extension TariffsViewController: UICollectionViewDelegateFlowLayout {
    
    //Устанавливаем высоту и ширину ячейки
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfCell: CGFloat = 3
        let cellWidth = collectionView.frame.size.width / numberOfCell

        let totalCellWidth = cellWidth - linespacing
        let size = CGSize(width: totalCellWidth, height: totalCellWidth / 1.275)

        return size
    }
    
    // Устанавливаем расстояние между ячейками
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return linespacing
    }
}
