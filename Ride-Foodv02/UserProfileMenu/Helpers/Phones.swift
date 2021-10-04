import Foundation


struct Phones: Codable {
    /*
     данная структура хранит список телефонов пользователя и текущий индекс телефона, который является основным
     Основные функции:
     - добавление телефона с кэшированием
     - удаление телефона с кэшированием
     - смена основного телефона с кэшированием
     - удаление всех телефонов( при выходе из профиля) с кэшированием
     */
    
    private(set) var currentPhoneID = 0
    private(set) var phones = [String]()
    
    static var shared = Phones()
    
    var json: Data? { try? JSONEncoder().encode(self) }
    
    init?(json:Data){
            if let newValue = try? JSONDecoder().decode(Phones.self, from: json) {
                self = newValue
            }
        }
    
    init() { }
    
    mutating func append(_ newPhone:String) {
        phones.append(newPhone)
        save()
    }
    
    mutating func removeAt(_ index:Int) {
        phones.remove(at: index)
        save()
    }
    
    mutating func change(_ newPhone:String,at index:Int) {
        phones[index] = newPhone
        save()
    }
    
    mutating func clear() {
        phones.removeAll()
        currentPhoneID = 0
        save()
    }
    
    mutating func changeIDTo(_ newValue:Int) {
        self.currentPhoneID = newValue
        save()
    }
    
    private func save() {
        if let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("phones"),
            let json = self.json {
                    try? json.write(to: url)
                }
    }
    
    mutating func recreate() {
        if let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("phones"),
           let data = try? Data(contentsOf: url),
           let newValue = Phones(json: data) {
                self = newValue
                save()
            }
    }
    
}
