//
//  MainScreenExtensions.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 19.08.2021.
//

import MapKit
import CoreLocation

extension MainScreenViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Получаем координаты пользователя при активной locationManager.startUpdatingLocation()
        if let loc = manager.location?.coordinate {

            let center = CLLocationCoordinate2D(latitude: loc.latitude, longitude: loc.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

            mapView.setRegion(region, animated: true)

            SetMapMarkersManager.shared.setMarkOn(map: mapView, with: loc) { address in
                self.foodTaxiView.placeLabel.text = address
                self.fromAddress = address
                MapKitManager.shared.locationManager.stopUpdatingLocation()
            }
        }
    }
    
    //Если пользователь изменил настройки авторизации, то проверяем заново
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        MapKitManager.shared.checkAuthorization(view: self)
    }
}

//MARK: - MapViewDelegate

extension MainScreenViewController: MKMapViewDelegate {
    
    //Задаем внещний вид маркеров для позиции от куда едем и куда
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let currentAnnotation = SetMapMarkersManager.shared.isFromAddressMarkSelected
        let imageAnnotation = currentAnnotation ? UIImage(named: "Annotation") : UIImage(named: "OrangeAnnotation")
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
        annotationView.image = imageAnnotation
        annotationView.frame.size = CGSize(width: 30, height: 48)

        return annotationView
    }
    
    //Задаем внешний вид линии траектории рассчитанного марщрута
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        
        let layerGradient = CAGradientLayer()
        layerGradient.colors = [
          UIColor(red: 0.239, green: 0.231, blue: 1, alpha: 1).cgColor,
          UIColor(red: 0.984, green: 0.557, blue: 0.314, alpha: 1).cgColor
        ]

        render.strokeColor = .blue
        render.lineWidth = 4
        
        
        return render
    }
}

//MARK: - PromotionView Delegate

extension MainScreenViewController: PromotionViewDelegate {
    
    func closePromotionView() {
        animationUerLocationButton()
    }
    
    func show() {
        transparentView.isHidden = false
        circleView.isHidden = true
        menuButton.isHidden = true
        let promotion = DefaultPromotion()
        promotionDetailView.headerLabel.text = promotion.title
        ImageFetcher.fetch(promotion.urlString) { data in
            self.promotionDetailView.imageView.image = UIImage(data: data)
        }
        PromotionsFetcher.getPromotionDescriptionWith(id: promotion.id) { [weak self] in
            self?.promotionDetailView.descriptionLabel.text = $0
        }
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: MainScreenConstants.durationForAppearingMenuView,
            delay: 0.0,
            options: .curveLinear,
            animations: {
                self.foodTaxiView.frame.origin.y = self.view.bounds.height + MainScreenConstants.promotionViewHeight + MainScreenConstants.foodTaxiYOffset
                self.promotionView.frame.origin.y = self.view.bounds.height
                self.promotionDetailView.frame.origin.y = 0
            })
    }
}

//MARK: - LocationChooserDelegate

extension MainScreenViewController: LocationChooserDelegate {
    
    func locationChoosen(_ newLocation: String) {
        toAddress = newLocation
    }
}

//MARK: - TableView datasourse

extension MainScreenViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodMainCell", for: indexPath)
        if let foodMainCell = cell as? FoodMainTableViewCell {
            foodMainCell.placeLabel.text = addresses[indexPath.row].title
            foodMainCell.addressLabel.text = addresses[indexPath.row].fullAddress
            return foodMainCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        toAddress = addresses[indexPath.row].fullAddress
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FoodConstants.tableViewRowHeight
    }
}

//MARK: - UItextfield delegate

extension MainScreenViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        moveDown()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        responderTextField = textField
        
        showMapItems(true)
        
        switch textField.tag {
        case 0:
            tableViewHeightView.isHidden = true
            addressesChooserViewHeightConstraint.constant -= tableViewHeightConstraint.constant
            tableViewHeightConstraint.constant = 0
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        case 1:
            tableViewHeightView.isHidden = false
            addresses.removeAll()
            loadAdressesFromCoreData()
            
        default:
            break
        }
    }
}

//MARK: - FromAddressDetailViewDelegate

extension MainScreenViewController: FromAddressDetailViewDelegate {
    
    func fromAddressDetailConfirm() {
        
        toAddressDetailView.isHidden = false
        
        toAddressDetailView.frame = CGRect(x: view.bounds.width,
                                           y: view.bounds.height - keyboardHeight - TaxiConstant.toAddressDetailViewHeight,
                                           width: view.bounds.width,
                                           height: TaxiConstant.toAddressDetailViewHeight)
        fromAddressDetailView.textField.resignFirstResponder()
        toAddressDetailView.textField.becomeFirstResponder()
        
        toAddressDetailView.placeLabel.text = toAddress
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0, options: .curveLinear) {
            self.toAddressDetailView.frame.origin.x = 0
            self.fromAddressDetailView.frame.origin.x = -self.view.bounds.width
        } completion: { if $0 == .end {}
        }

    }
}

//MARK: - ToAddressesDetaileViewDelegate

extension MainScreenViewController: ToAddressDetailViewDelegate {
    
    func toAddressDetailConfirm() {
        transparentView.isHidden = true
        bottomConstaint.constant = 0.0
        toAddressDetailView.textField.resignFirstResponder()
        addressesChooserView.isUserInteractionEnabled = false
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0, options: .curveLinear) {
            self.toAddressDetailView.frame.origin.x = -self.view.bounds.width
        } completion: { if $0 == .end {
            self.toAddressDetailView.removeFromSuperview()
            self.fromAddressDetailView.removeFromSuperview()
            self.shouldUpdateUI = true
            self.addressesChooserView.isUserInteractionEnabled = true
            self.shouldMakeOrder = true
        }
        }
        CalculatingPathManager.shared.calculatingPath(for: mapView) { pathTime in
            self.pathTime(minutes: pathTime)
        }
        
        SetMapMarkersManager.shared.isPathCalculeted = true
        gradientImageView?.isHidden = fromAddress.isEmpty || toAddress.isEmpty
        showMapItems(true)
    }
}

//MARK: - TaxiTariffViewDelegate

extension MainScreenViewController: TaxiTariffViewDelegate {
    
    
    func useScores() {
        if !taxiTariffView.usedScores && taxiTariffView.selectedIndex != nil {
            wholeTransparentView.isHidden = false
            scoresView.isHidden = false
            scoresView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: 170)
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0, options: .curveLinear) {
                self.scoresView.frame.origin.y = self.view.bounds.height - 170
            }
        }

    }
    
    func usePromocode() {
        if !taxiTariffView.usedPromocode {
            shouldUpdateUI = false
            wholeTransparentView.isHidden = false
            promocodeToolbar.isHidden = false
            promocodeToolbar.textField.becomeFirstResponder()
            promocodeToolbar.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: PromocodeConstant.toolbarHeight)
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0, options: .curveLinear) {
                self.promocodeToolbar.frame.origin.y = self.view.bounds.height - self.keyboardHeight - PromocodeConstant.toolbarHeight
            }

        }
    }
    
    func tariffEntered() {
        roundedView.colorToFill = #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1)
        roundedView.isUserInteractionEnabled = true
    }
    
}

//MARK: - ScoresViewDelegate

extension MainScreenViewController: ScoresViewDelegate {
    
    func showScoresToolbar() {
        scoresToolbar.isHidden = false
        shouldUpdateUI = false
        scoresToolbar.scores = scoresView.scores
        scoresToolbar.textField.becomeFirstResponder()
        scoresToolbar.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: 128)
        shouldUpdateUI = false
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0, options: .curveLinear) {
            self.scoresToolbar.frame.origin.y = self.view.bounds.height - self.keyboardHeight - 128
        }

    }
    
    func closeScoresView() {
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0, options: .curveLinear) {
            self.scoresView.frame.origin.y = self.view.bounds.height
        }completion: { if $0 == .end {
            self.wholeTransparentView.isHidden = true
            self.scoresView.isHidden = true
        }}
    }
    
    func spendAllScores() {
        enter(scores: scoresView.scores)
    }
}

//MARK: - ScoresToolbarDelegate

extension MainScreenViewController: ScoresToolbarDelegate {
    
    func closeScoresToolbar() {
        
        scoresToolbar.textField.resignFirstResponder()
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: .curveLinear) {
            self.scoresToolbar.frame.origin.y = self.view.bounds.height
        } completion: {  if $0 == .end {
            self.scoresToolbar.isHidden = true
        }
        }
    }
    
    func enter(scores: Int) {
        closeScoresToolbar()
        closeScoresView()
        taxiTariffView.updateUIWith(scores: scores)
    }
}

//MARK: - MenuViewDelegate

extension MainScreenViewController: MenuViewDelegate {

    func close() {
        transparentView.isHidden = true
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: MainScreenConstants.durationForDisappearingMenuView,
            delay: 0.0,
            options: .curveLinear,
            animations: {
                self.resetFrames()
            }) {
            if $0 == .end { self.menuView.isVisible = false }
        }
    }
    
    func goToStoryboard(_ name:String) {
        let storyboard = UIStoryboard(name: name, bundle: .main)
        if let supportVC = storyboard.instantiateInitialViewController() {
            supportVC.modalPresentationStyle = .fullScreen
            supportVC.modalTransitionStyle = .coverVertical
            present(supportVC, animated: true)
        }
    }
}

//MARK: - FoodTaxiView Delegate

extension MainScreenViewController: FoodTaxiViewDelegate {
    
    func goToFood() {
        UIView.animate(withDuration: MainScreenConstants.durationForAppearingPromotionView) {
            self.promotionView.alpha = 0
        }
        performSegue(withIdentifier: "food", sender: nil)
    }
    
    func goToTaxi() {
        loadSetupsTaxi()
    }
}

//MARK: - PromotionDetail Delegate

extension MainScreenViewController: PromotionDetailDelegate {
    
    func dismiss() {
        transparentView.isHidden = true
        circleView.isHidden = false
        menuButton.isHidden = false
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: MainScreenConstants.durationForAppearingMenuView,
            delay: 0.0,
            options: .curveLinear,
            animations: {
                self.resetFrames()
            })
    }
}

//MARK: - FoodMainDelegate

extension MainScreenViewController: FoodMainDelegate {
    
    func done() {
        transparentView.isHidden = true
        UIView.animate(withDuration: MainScreenConstants.durationForAppearingPromotionView) {
            self.promotionView.alpha = 1
        }
    }
}

//MARK: - SetMapMarkerDelegate

extension MainScreenViewController: SetMapMarkersDelegate {
    
    func zoomAllMarketsOnMap() {
        if mapView.annotations.count < 2 {
            guard let coordinate = MapKitManager.shared.currentUserCoordinate else { return }
            let center = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

            mapView.setRegion(region, animated: true)
        } else {
            mapView.fitAllAnnotations(with: UIEdgeInsets(top: 100, left: 50, bottom: 50 + addressesChooserView.frame.height, right: 50))
        }
    }
    
    func pathTime(minutes: Int) {
        timeLabel.text = "≈\(minutes) \(Localizable.Taxi.minutes.localized)"
        pathTimeView.alpha = 1
    }
}

//MARK: - SetToLocationdelegate

extension MainScreenViewController: SetToLocationDelegate {
    
    func pressConfirm() {
        
        isMainScreen = true
        
        //setToLocationView.endEditing(true)
        //toTextField.becomeFirstResponder()
        

        
        UIView.animate(withDuration: 0.5) {
            
            self.setToLocationView.frame.origin.y = self.view.frame.height
            
            //self.setToLocationView.frame.origin.y = self.view.frame.height
            
        } completion: { _ in
            self.setToLocationView.removeFromSuperview()
            self.bottomConstaint.constant = 0
            UIView.animate(withDuration: 0.5) {
                self.menuButton.alpha = 1
                self.circleView.alpha = 1
                self.promotionView.alpha = 0
                self.view.layoutIfNeeded()
            }
            self.setFromMarket()
            self.setToMarker()
            //self.moveDown()
            //self.setToLocationView.removeFromSuperview()
            
            //self.transparentView.isHidden = false
            //self.bottomConstaint.constant = 0
        }
    }
}

extension MainScreenViewController: PromocodeToolbarDelegate {
    
    func activate(promocode: String) {
        taxiTariffView.usedPromocode = true
        promocodeToolbar.textField.resignFirstResponder()
        promocodeActivationView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: 230)
        promocodeActivationView.isHidden = false
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: .curveLinear) {
            self.promocodeToolbar.frame.origin.y = self.view.bounds.height
            self.promocodeActivationView.frame.origin.y = self.view.bounds.height - 230
        }
    }
    
    func closePromocodeToolbar() {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: .curveLinear) {
            self.promocodeToolbar.frame.origin.y = self.view.bounds.height
        } completion: {  if $0 == .end {
            self.promocodeToolbar.isHidden = true
            self.wholeTransparentView.isHidden = true
            self.shouldUpdateUI = true
        }
        }
    }
}

//MARK: - PromocodeActivatorDelegate

extension MainScreenViewController: PromocodeActivationDelegate {
    
    func closePromocodeActivationView() {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0, options: .curveLinear) {
            self.promocodeActivationView.frame.origin.y = self.view.bounds.height
        } completion: { if $0 == .end {
            self.promocodeActivationView.isHidden = true
            self.wholeTransparentView.isHidden = true
            self.shouldUpdateUI = true
        }
        }

    }
    
    
    

    
    
}
