//
//  BookingModel.swift
//  MegafonTest
//
//  Created by Ботурбек Имомдодов on 26/01/25.
//

import Foundation

struct Booking {
    let name: String
    let image: URL?
    let rating: Float
    let price: Float
    let distance: Float
    var guestCount: Int
    
    var isBooked: Bool {
        return entity != nil
    }
    
    let entity: HotelEntity?
    
    init(
        name: String,
        image: URL?,
        rating: Float,
        price: Float,
        distance: Float,
        guestCount: Int
    ) {
        self.name = name
        self.image = image
        self.rating = rating
        self.price = price
        self.distance = distance
        self.guestCount = guestCount
        self.entity = nil
    }
    
    init(entity: HotelEntity) {
        self.entity = entity
        self.name = entity.name ?? ""
        self.image = entity.image
        self.rating = entity.rating
        self.price = entity.price
        self.distance = entity.distance
        self.guestCount = Int(entity.guestCount)
    }
}
