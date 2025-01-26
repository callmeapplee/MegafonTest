//
//  HotelDetailViewModel.swift
//  MegafonTest
//
//  Created by Ботурбек Имомдодов on 26/01/25.
//

import Foundation
import RxSwift
import RxCocoa

class HotelDetailViewModel {
    let booking: BehaviorRelay<Booking>
    private let disposeBag = DisposeBag()
    
    init(booking: Booking) {
        self.booking = BehaviorRelay<Booking>(value: booking)
    }
    
    func book() {
        if let entity = booking.value.entity {
            entity.guestCount = Int16(booking.value.guestCount)
            CoreDataService.shared.saveContext()
        }
        else {
            CoreDataService.shared.saveHotel(
                name: booking.value.name,
                rating: booking.value.rating,
                price: booking.value.price,
                distance: booking.value.distance,
                guestCount: booking.value.guestCount
            )
        }
    }
}
