//
//  Order.swift
//  CakeCorner
//
//  Created by Elman Asadi on 2/22/22.
//

import SwiftUI

class Order : ObservableObject, Codable {
    
    enum CodingKeys : CodingKey { case type, quantity, extraFrosting, addSprinkles, name, streetAddress, city, zip }
    
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    @Published var type = 0
    @Published var quantity = 3
    
    @Published var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    @Published var extraFrosting = false
    @Published var addSprinkles = false
    
    @Published var name = ""
    @Published var streetAddress = ""
    @Published var city = ""
    @Published var zip = ""
    
    var hasValidAddress : Bool {
        if name.isEmpty || streetAddress.isEmpty || city.isEmpty || zip.isEmpty {
            return false
        }
        return true
    }
    
    
    var cost : Double {
        var cost = Double(quantity) * 2
        cost += (Double(type) / 2)
        
        if extraFrosting {
            cost += Double(quantity)
        }
        
        if addSprinkles {
            cost += Double(quantity) / 2
        }
        return cost
    }
    
    
    init() {}
    
    
    func encode(to encoder: Encoder) throws {
        var contianer = encoder.container(keyedBy: CodingKeys.self)
        
        try contianer.encode(type, forKey: .type)
        try contianer.encode(quantity, forKey: .quantity)
        
        try contianer.encode(extraFrosting, forKey: .extraFrosting)
        try contianer.encode(addSprinkles, forKey: .addSprinkles)
        
        try contianer.encode(name, forKey: .name)
        try contianer.encode(streetAddress, forKey: .streetAddress)
        try contianer.encode(city, forKey: .city)
        try contianer.encode(zip, forKey: .zip)
    }
    
    required init(from decoder: Decoder) throws {
        let container  = try decoder.container(keyedBy: CodingKeys.self)
        
        type = try container.decode(Int.self, forKey: .type)
        quantity = try container.decode(Int.self, forKey: .quantity)
        
        extraFrosting = try container.decode(Bool.self, forKey: .extraFrosting)
        addSprinkles = try container.decode(Bool.self, forKey: .addSprinkles)
        
        name = try container.decode(String.self, forKey: .name)
        streetAddress = try container.decode(String.self, forKey: .streetAddress)
        city = try container.decode(String.self, forKey: .city)
        zip = try container.decode(String.self, forKey: .zip)
    }
    
    
}
