//
//  MainScreenExtensions.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 19.08.2021.
//

import MapKit
import CoreLocation

//MARK: - CLLocationManagerDelegate

extension MainScreenViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Получаем координаты пользователя при активной locationManager.startUpdatingLocation()
        if let loc = manager.location?.coordinate {

            SetMapMarkersManager.shared.setMarkOn(map: mapView, with: loc) { address in
                self.foodTaxiView.placeLabel.text = address
                self.fromAddress = address
                MapKitManager.shared.locationManager.stopUpdatingLocation()
                self.zoomOneMarker()
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
        animationUserLocationButton()
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

//extension MainScreenViewController: LocationChooserDelegate {
//    
//    func locationChoosen(_ newLocation: String) {
//        toAddress = newLocation
//    }
//}

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
        
        if addresses.isEmpty { loadAdressesFromCoreData() }
        
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
        
        fromTextField.isUserInteractionEnabled = false
        toTextField.isUserInteractionEnabled = false
        
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
        userLocationButtonBottomConstraint.constant = addressesChooserViewHeightConstraint.constant - safeAreaBottomHeight
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
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
    func tariffEntered(index: Int) {
        
        roundedView.colorToFill = #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1)
        roundedView.isUserInteractionEnabled = true
        nextButton.isUserInteractionEnabled = true
        taxiTariffSelected = index
    }
}


//MARK: - PromocodeScoresViewDelegate

extension MainScreenViewController: PromocodeScoresViewDelegate {
    
    func useScores() {
        if taxiTariffView.selectedIndex != nil {
            wholeTransparentView.isHidden = false
            scoresView.isHidden = false
            scoresView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: 170)
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0, options: .curveLinear) {
                self.scoresView.frame.origin.y = self.view.bounds.height - 170
            }
            
            guard let userID = userID else { return }
            
            DispatchQueue.global(qos: .userInitiated).async {
                let totalScoresInteractor = TotalScoresInteractor()
                totalScoresInteractor.loadScores(userID: userID) { data in
                    DispatchQueue.main.async {
                        self.scoresView.scores = data.credit
                    }
                }
            }
            
        }

    }
    
    func usePromocode() {
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

//MARK: - ScoresViewDelegate

extension MainScreenViewController: ScoresViewDelegate {
    
    func showScoresToolbar() {
        scoresToolbar.isHidden = false
        shouldUpdateUI = false
        scoresToolbar.scores = scoresView.scores
        scoresToolbar.textField.becomeFirstResponder()
        scoresToolbar.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: 128)
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
            self.shouldUpdateUI = true
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
            self.shouldUpdateUI = true
            }
        }
    }
    
    func enter(scores: Int) {
        closeScoresToolbar()
        closeScoresView()
        taxiTariffView.scoresEntered = scores
        promocodeScoresView.scores = scores
        taxiTariffView.updateUIWith(scores: scores)
    }
}

//MARK: - MenuViewDelegate

extension MainScreenViewController: MenuViewDelegate {

    func close() {
        if menuView.isVisible {
            transparentView.isHidden = true
            userLocationButtonOutlet.isHidden = false
            circleView.isHidden = false
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: MainScreenConstants.durationForDisappearingMenuView,
                delay: 0.0,
                options: .curveLinear,
                animations: { self.resetFrames() } ) {
                if $0 == .end {
                    self.menuView.isVisible = false
                    self.profileButton.isUserInteractionEnabled = true
                    self.userLocationButtonOutlet.isUserInteractionEnabled = true
                }
            }
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
        
        if isTaxiOrdered {
            let lowPosY = self.view.frame.height - self.foodTaxiView.frame.height - 35
            UIView.animate(withDuration: 0.5) {
                self.taxiOrderInfoView.frame.origin.y = lowPosY
            }
        }
        
        UIView.animate(withDuration: MainScreenConstants.durationForAppearingPromotionView) {
            self.promotionView.alpha = 0
        }
        performSegue(withIdentifier: "food", sender: nil)
    }
    
    func goToTaxi() {
        
        if isFoodOrdered {
            let lowPosY = self.view.frame.height - self.foodTaxiView.frame.height - 35
            UIView.animate(withDuration: 0.5) {
                self.foodOrderInfoView.frame.origin.y = lowPosY
            }
        }
        
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
    
    func zoomOneMarker() {
        
        guard let coordinate = MapKitManager.shared.currentUserCoordinate else { return }
        
        let regionRadius: CLLocationDistance = 500
        let coordinateRegion = MKCoordinateRegion(center: coordinate,
                                                  latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    

    
    func pathTime(minutes: Int) {
        timeLabel.text = "≈\(minutes) \(Localizable.Taxi.minutes.localized)"
        pathTimeView.alpha = 1
    }
}

//MARK: - SetToLocationdelegate

extension MainScreenViewController: SetToLocationDelegate {
    
    func pressConfirm() {

        UIView.animate(withDuration: 0.5) {
            
            self.setToLocationView.frame.origin.y = self.view.frame.height
            
        } completion: { _ in
            self.setToLocationView.removeFromSuperview()
            self.bottomConstaint.constant = 0
            UIView.animate(withDuration: 0.5) {
                self.promotionView.alpha = 0
                self.view.layoutIfNeeded()
            }
            self.setToAndFromMarkers()
            self.moveDown()
            self.zoomAllMarkers()
        }
    }
    
    func zoomAllMarkers() {
        
        guard let coordinate = MapKitManager.shared.currentUserCoordinate else { return }
        let regionRadius: CLLocationDistance = 500
        //let center =
        let coordinateRegion = MKCoordinateRegion(center: coordinate,
                                                  latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

extension MainScreenViewController: PromocodeToolbarDelegate {
    
    func activate(promocode: String) {
        PromocodeActivator.post(code: promocode)
        promocodeToolbar.spinner.startAnimating()
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


//MARK: - PromocodeActivatorDelegate

extension MainScreenViewController: PromocodeActivatorDelegate {
    
    func promocodeActivated(_ description: String) {
        promocodeScoresView.usedPromocode = true
        promocodeToolbar.textField.resignFirstResponder()
        promocodeActivationView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: 230)
        promocodeActivationView.bodyLabel.text = description
        promocodeActivationView.isHidden = false
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: .curveLinear) {
            self.promocodeToolbar.frame.origin.y = self.view.bounds.height
            self.promocodeActivationView.frame.origin.y = self.view.bounds.height - 230
        }
    }
    
    func promocodeFailed(_ error: String) {
        promocodeToolbar.lineView.backgroundColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
        promocodeToolbar.errorLabel.isHidden = false
        promocodeToolbar.errorLabel.text = error
        promocodeToolbar.spinner.stopAnimating()
    }
    
    
}

//MARK: - OrderCompleteViewDelegate
extension MainScreenViewController: OrderCompleteViewDelegate {
    
    func orderCompleteViewClose() {
        userLocationButtonOutlet.isHidden = true
        promotionView.isHidden = true
        menuButton.isUserInteractionEnabled = true
        profileButton.isUserInteractionEnabled = true
        mapView.isUserInteractionEnabled = true
        
//        for gesture in mapView.gestureRecognizers! {
//            if gesture is UITapGestureRecognizer {
//                mapView.removeGestureRecognizer(gesture)
//            }
//        }
//        view.addSubview(deliveryMainView)
//        deliveryMainView.delegate = self
//        deliveryMainView.frame = CGRect(x: 0, y: view.bounds.height - MainScreenConstants.foodTaxiViewHeight - MainScreenConstants.foodTaxiYOffset - bottomSafeAreaConstant - MainScreenConstants.promotionViewHeight, width: view.bounds.width, height: MainScreenConstants.promotionViewHeight)
//        deliveryMainView.alpha = 0
//        pathTimeView.alpha = 1
        foodTaxiView.foodImageView.isUserInteractionEnabled = false
        foodTaxiView.foodImageView.image = #imageLiteral(resourceName: "FoodInActive")
//        timeLabel.text = "1 \(Localizable.Delivery.deliveryActiveOrder.localized)"
//        UIView.animate(withDuration: 0.25) {
//            self.view.layoutIfNeeded()
            //self.deliveryMainView.alpha = 1.0
//        }
        
        pressFoodOrderButton()
    }
    
    
    
}


//MARK: - De

extension MainScreenViewController: DeliveryMainViewDelegate {
    
    func deliveryMainViewClose() {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0, options: .curveLinear) {
            self.deliveryMainView.alpha = 0
        } completion: { if $0 == .end {
            self.deliveryMainView.removeFromSuperview()
        }
        }

    }
    
    
}

extension MainScreenViewController: DriverSearchDelegate {
    func confirm(time: String) {
        DispatchQueue.main.async {
            self.timeRemainig = time
            self.pressTaxiOrderButton()
        }
      
    }
    
    func cancel() {
        DispatchQueue.main.async {
                self.isTaxiOrdered = false
                self.containerView.frame.origin.y = self.view.frame.height
                self.containerView.removeFromSuperview()
                self.view.layoutIfNeeded()
            self.returnToMainView()
        
        }
          
    
    }
    
    func changeFrame() {
        self.setContainerViewFrame(with: .found)
    }
    
    
}
