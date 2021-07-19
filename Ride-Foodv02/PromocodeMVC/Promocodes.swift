import Foundation


class Promocodes {
    
    
    static let active: [Promocode] = [
        Promocode(title: "R - 1450366", description: "- 50% в сети магазинов Перекрёсток, Лента, Мясновъ", status: .active, statusDescription: "Истекает через: 5 дней"),
        Promocode(title: "R - 1450882", description: "- 30% на любой тариф в сервисе «Такси»", status: .active, statusDescription: "Истекает через: 7 дней"),
        Promocode(title: "R - 1450445", description: "- 15% на заказ в сервисе «Еда»", status: .active, statusDescription: "Истекает через: 8 дней"),
        Promocode(title: "R - 1450892", description: "- 10% на поездку по тарифу Premium", status: .active, statusDescription: "Истекает через: 9 дней "),
        Promocode(title: "R - 1454574", description: "- 20% на поездку по тарифу Standart", status: .active, statusDescription: "Истекает через: 11 дней"),
        Promocode(title: "R - 1454572", description: "- 10% на поездку по тарифу Business", status: .active, statusDescription: "Истекает через: 14 дней")
    ]
    
    static let inActive: [Promocode] = [
        Promocode(title: "R - 1450892", description: "- 10% на поездку по тарифу Premium", status: .activated, statusDescription: "Промокод был использован: 03.09.20"),
        Promocode(title: "R - 1454574", description: "- 20% на поездку по тарифу Standart", status: .expired, statusDescription: "Истёк срок действия: 24.08.20"),
        Promocode(title: "R - 1454572", description: "- 10% на поездку по тарифу Business   ", status: .activated, statusDescription: "Промокод был использован: 20.08.20"),
        Promocode(title: "R - 1450366", description: "- 50% в сети магазинов Перекрёсток, Лента, Мясновъ", status: .expired, statusDescription: "Истёк срок действия: 16.08.20"),
        Promocode(title: "R - 1450882", description: "- 30% на любой тариф в сервисе «Такси»", status: .activated, statusDescription: "Промокод был использован: 14.08.20"),
        Promocode(title: "R - 1450445", description: "- 15% на заказ в сервисе «Еда» ", status: .activated, statusDescription: "Промокод был использован: 11.08.20")
    ]
    
    
}
