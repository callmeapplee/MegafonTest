//
//  HotelDetailViewModel.swift
//  MegafonTest
//
//  Created by Ботурбек Имомдодов on 26/01/25.
//

import Foundation

class HotelDetailViewModel {
    var booking: Box<Booking>
    
    init(booking: Booking) {
        self.booking = Box<Booking>(booking)
    }
    
    func book() {
        if let entity = booking.value.entity {
            entity.guestCount = Int16(booking.value.guestCount)
            CoreDataService.shared.saveContext()
        }
        else {
            NotificationService.shared.scheduleCheckInReminder(for: booking.value.checkInDate)
            let entity = CoreDataService.shared.saveHotel(
                name: booking.value.name,
                rating: booking.value.rating,
                price: booking.value.price,
                distance: booking.value.distance,
                guestCount: booking.value.guestCount,
                checkInDate: booking.value.checkInDate,
                checkOutDate: booking.value.checkOutDate
            )
            var currentBooking = booking.value
            currentBooking.entity = entity
            booking.value = currentBooking
        }
    }
}
