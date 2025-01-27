//
//  BookingViewModel.swift
//  MegafonTest
//
//  Created by Ботурбек Имомдодов on 26/01/25.
//


class BookingViewModel {
    let bookings: Box<[Booking]> = Box([])
    
    init() {
        fetchBookings()
    }
    
    func fetchBookings() {
        do {
            let entities = try CoreDataService.shared.fetchHotels()
            let fetchedBookings = entities.map { Booking(entity: $0) }
            bookings.value = fetchedBookings
        } catch let error {
            print("Error fetching bookings: \(error)")
        }
    }
    
    func deleteBooking(at index: Int) {
        var currentBookings = bookings.value
        let booking = currentBookings.remove(at: index)
        bookings.value = currentBookings
        
        if let entity = booking.entity {
            CoreDataService.shared.deleteHotel(hotel: entity)
        }
    }
}
