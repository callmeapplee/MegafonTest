//
//  HotelModel.swift
//  MegafonTest
//
//  Created by Ботурбек Имомдодов on 25/01/25.
//

import Foundation

struct Hotel {
    let name: String
    let image: URL?
    let rating: Float
    let price: Float
    let distance: Float
    
    func isMatch(by filter: Filter) -> Bool {
        return (name.lowercased().contains(filter.searchQuery.lowercased()) || filter.searchQuery.isEmpty) &&
            price <= filter.priceRange &&
            rating >= filter.rating &&
            distance <= filter.distance
    }
}
