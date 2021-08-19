import Foundation

struct PromotionDataModel: Decodable {
    var data: [PromotionModel]
}

struct PromotionDetailModel: Decodable {
    var data: PromotionModel
}

struct PromotionModel: Decodable {
    
    var id:Int
    var date_from: String?
    var date_to: String
    var time_from: String?
    var time_to: String?
    var type: String
    var title: String
    var description: String?
    var media: [Media]
}

struct Media: Decodable {
    
    var url: String
    var file_name: String
    var mime_type: String
    var size: Int
    var created_at: Int
    var updated_at: Int
    
}
