//
//  HotelSearchViewModel.swift
//  MegafonTest
//
//  Created by Ботурбек Имомдодов on 25/01/25.
//

import RxSwift
import RxCocoa

class HotelSearchViewModel {
    let hotels = BehaviorRelay<[Hotel]>(value: [])
    let filteredHotels = BehaviorRelay<[Hotel]>(value: [])
    let filter = BehaviorRelay<Filter>(value: Filter())

    private let disposeBag = DisposeBag()

    init() {
        loadMockHotels()

        Observable.combineLatest(hotels, filter)
            .map { hotels, filter in
                hotels.filter { $0.isMatch(by: filter) }
            }
            .bind(to: filteredHotels)
            .disposed(by: disposeBag)
    }

    private func loadMockHotels() {
        let mockData: [Hotel] = [
            Hotel(
                name: "Seaside Resort",
                image: nil,
                rating: 4.7,
                price: 200.0,
                distance: 0.5
            ),
            Hotel(
                name: "Mountain Retreat",
                image: nil,
                rating: 4.3,
                price: 150.0,
                distance: 1.2
            ),
            Hotel(
                name: "City Center Hotel",
                image: nil,
                rating: 4.5,
                price: 180.0,
                distance: 0.2
            ),
            Hotel(
                name: "Desert Oasis",
                image: nil,
                rating: 4.9,
                price: 250.0,
                distance: 3.5
            ),
            Hotel(
                name: "Lakeview Resort",
                image: nil,
                rating: 4.6,
                price: 220.0,
                distance: 0.8
            )
        ]

        hotels.accept(mockData)
    }
}

