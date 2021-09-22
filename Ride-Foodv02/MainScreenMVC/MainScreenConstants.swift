import Foundation
import CoreGraphics

struct MainScreenConstants {

    static let durationForAppearingMenuView = 0.25
    static let durationForDisappearingMenuView = 0.25
    static let durationForAppearingPromotionView = 0.45
    
    
    static let menuViewXOffset: CGFloat = 42.0
    static let foodTaxiViewHeight: CGFloat = 140.0
    static let foodTaxiYOffset: CGFloat = 13.0
    static let promotionViewHeight: CGFloat = 45.0
    
    static let searchDriverScreenHeight: CGFloat = 150
    static let foundDriverScreenHeight: CGFloat = 620
    
    static let demoOrderData: OrderData = OrderData(data: DataClass(id: 1,
                                                                    userid: 1,
                                                                    from: "Красная площадь",
                                                                    to: "Большой театр",
                                                                    credit: 20,
                                                                    distance: 15,
                                                                    price: 150,
                                                                    discount: 20,
                                                                    forPayment: 0,
                                                                    type: "Apple Pay",
                                                                    status: "В пути",
                                                                    comment: nil ,
                                                                    tariff: nil,
                                                                    promoCodes: nil,
                                                                    availablePromoCodes: nil,
                                                                    taxi: Taxi(id: 2,
                                                                               car: "Toyota Corolla",
                                                                               color: "Белая",
                                                                               number: "O224E",
                                                                               regionNumber: 434,
                                                                               imageMap: "",
                                                                               imageOrder: "",
                                                                               imageHistory: ""),
                                                                    products: nil))
    
}
