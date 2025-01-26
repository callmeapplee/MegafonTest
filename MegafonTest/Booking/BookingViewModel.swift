//
//  BookingViewModel.swift
//  MegafonTest
//
//  Created by Ботурбек Имомдодов on 26/01/25.
//

import RxSwift
import RxCocoa

class BookingViewModel {
    
    private let disposeBag = DisposeBag()
    
    let bookings: BehaviorRelay<[Booking]> = BehaviorRelay(value: [])
    
    init() {
        fetchBookings()
    }
    
    func fetchBookings() {
        do {
            let entities = try CoreDataService.shared.fetchHotels()
            let bookings = entities.map { Booking(entity: $0) }
            
            self.bookings.accept(bookings)
        }
        catch(let error) {
            print("Error fetching bookings: \(error)")
        }
    }
    
    func deleteBooking(at index: Int) {
        var currentBookings = bookings.value
        let booking = currentBookings.remove(at: index)
        
        bookings.accept(currentBookings)
        
        if let entity = booking.entity {
            CoreDataService.shared.deleteHotel(hotel: entity)
        }
    }
}
