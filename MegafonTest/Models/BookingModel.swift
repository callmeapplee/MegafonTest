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
    var checkInDate: Date
    var checkOutDate: Date?
    
    var isBooked: Bool {
        return entity != nil
    }
    
    var entity: HotelEntity?
    
    init(
        name: String,
        image: URL?,
        rating: Float,
        price: Float,
        distance: Float,
        guestCount: Int,
        checkInDate: Date,
        checkOutDate: Date?
    ) {
        self.name = name
        self.image = image
        self.rating = rating
        self.price = price
        self.distance = distance
        self.guestCount = guestCount
        self.entity = nil
        self.checkInDate = checkInDate
        self.checkOutDate = checkOutDate
    }
    
    init(entity: HotelEntity) {
        self.entity = entity
        self.name = entity.name ?? ""
        self.image = entity.image
        self.rating = entity.rating
        self.price = entity.price
        self.distance = entity.distance
        self.checkInDate = entity.checkInDate ?? Date()
        self.checkOutDate = entity.checkOutDate
        self.guestCount = Int(entity.guestCount)
    }
}
