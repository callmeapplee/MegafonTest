//
//  HotelSearchViewModel.swift
//  MegafonTest
//
//  Created by Ботурбек Имомдодов on 25/01/25.
//


class HotelSearchViewModel {
    let hotels: Box<[Hotel]> = Box([])
    let filteredHotels: Box<[Hotel]> = Box([])
    let filter: Box<Filter> = Box(Filter())
    
    init() {
        loadMockHotels()
        applyFilter()
    }
    
    private func loadMockHotels() {
        let mockData: [Hotel] = [
            Hotel(name: "Seaside Resort", image: nil, rating: 4.7, price: 200.0, distance: 0.5),
            Hotel(name: "Mountain Retreat", image: nil, rating: 4.3, price: 150.0, distance: 1.2),
            Hotel(name: "City Center Hotel", image: nil, rating: 4.5, price: 180.0, distance: 0.2),
            Hotel(name: "Desert Oasis", image: nil, rating: 4.9, price: 250.0, distance: 3.5),
            Hotel(name: "Lakeview Resort", image: nil, rating: 4.6, price: 220.0, distance: 0.8)
        ]
        hotels.value = mockData
    }
    
    func getBooking(by hotel: Hotel) -> Booking {
        return Booking(
            name: hotel.name,
            image: hotel.image,
            rating: hotel.rating,
            price: hotel.price,
            distance: hotel.distance,
            guestCount: 1,
            checkInDate: filter.value.checkInDate,
            checkOutDate: filter.value.checkInDate == filter.value.checkOutDate ? filter.value.checkOutDate : nil
        )
    }
    
    private func applyFilter() {
        filter.bind { [weak self] filter in
            guard let self = self else { return }
            self.filteredHotels.value = self.hotels.value.filter { $0.isMatch(by: filter) }
        }
    }
}
