
import Foundation


struct InspectionDetailsDropDataWrapper: Codable {
    let status: Int
    let message: String
    let data: IDDropDownData
}

// MARK: - DataClass
struct IDDropDownData: Codable {
    let activity : [IDActivityData]
    let relation : [IDRelationData]
    let site : [IDSiteData]
    let check : [IDCheckData]
    let attendance : [IDAttendanceData]

    enum CodingKeys: String, CodingKey {
        case activity = "activity"
        case relation = "relation"
        case site = "site"
        case check = "check"
        case attendance = "attendance"
    }

}


struct IDActivityData: Codable {
    
    var activity_id = ""
    var activity_details = ""

    enum CodingKeys: String, CodingKey {
        case activity_id = "activity_id"
        case activity_details = "activity_details"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let activity_id = try? container.decode(String.self, forKey: .activity_id){
            self.activity_id = activity_id
        }
        if let activity_details = try? container.decode(String.self, forKey: .activity_details){
            self.activity_details = activity_details
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(activity_id, forKey: .activity_id)
        try container.encode(activity_details, forKey: .activity_details)
    }
}

struct IDRelationData: Codable {
    
    var relationship_id = ""
    var relationship_descript = ""

    enum CodingKeys: String, CodingKey {
        case relationship_id = "relationship_id"
        case relationship_descript = "relationship_descript"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let relationship_id = try? container.decode(String.self, forKey: .relationship_id){
            self.relationship_id = relationship_id
        }
        if let relationship_descript = try? container.decode(String.self, forKey: .relationship_descript){
            self.relationship_descript = relationship_descript
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(relationship_id, forKey: .relationship_id)
        try container.encode(relationship_descript, forKey: .relationship_descript)
    }
}

struct IDSiteData: Codable {
    
    var site_id = ""
    var site_name = ""
    var site_brief = ""


    enum CodingKeys: String, CodingKey {
        case site_id = "site_id"
        case site_name = "site_name"
        case site_brief = "site_brief"

    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let site_id = try? container.decode(String.self, forKey: .site_id){
            self.site_id = site_id
        }
        if let site_name = try? container.decode(String.self, forKey: .site_name){
            self.site_name = site_name
        }
        if let site_brief = try? container.decode(String.self, forKey: .site_brief){
            self.site_brief = site_brief
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(site_id, forKey: .site_id)
        try container.encode(site_name, forKey: .site_name)
        try container.encode(site_brief, forKey: .site_brief)
    }
}

struct IDCheckData: Codable {
    
    var check_type_id = ""
    var check_type_details = ""

    enum CodingKeys: String, CodingKey {
        case check_type_id = "check_type_id"
        case check_type_details = "check_type_details"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let check_type_id = try? container.decode(String.self, forKey: .check_type_id){
            self.check_type_id = check_type_id
        }
        if let check_type_details = try? container.decode(String.self, forKey: .check_type_details){
            self.check_type_details = check_type_details
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(check_type_id, forKey: .check_type_id)
        try container.encode(check_type_details, forKey: .check_type_details)
    }
}

struct IDAttendanceData: Codable {
    
    var attendance_type_id = ""
    var attendance_details = ""

    enum CodingKeys: String, CodingKey {
        case attendance_type_id = "attendance_type_id"
        case attendance_details = "attendance_details"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let attendance_type_id = try? container.decode(String.self, forKey: .attendance_type_id){
            self.attendance_type_id = attendance_type_id
        }
        if let attendance_details = try? container.decode(String.self, forKey: .attendance_details){
            self.attendance_details = attendance_details
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(attendance_type_id, forKey: .attendance_type_id)
        try container.encode(attendance_details, forKey: .attendance_details)
    }
}

