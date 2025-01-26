//
//  CoreDataService.swift
//  MegafonTest
//
//  Created by Ботурбек Имомдодов on 26/01/25.
//

import Foundation
import CoreData

class CoreDataService {
    static let shared = CoreDataService()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Booking")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error \(error), \(error.localizedDescription)")
            }
        })
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            }
            catch(let error) {
                fatalError("Unresolved error \(error)")
            }
        }
    }
    
    func fetchHotels() throws -> [HotelEntity] {
        let fetchRequest: NSFetchRequest<HotelEntity> = HotelEntity.fetchRequest()
        return try persistentContainer.viewContext.fetch(fetchRequest)
    }
    
    func saveHotel(name: String, rating: Float, price: Float, distance: Float, guestCount: Int) {
        let hotel = HotelEntity(context: persistentContainer.viewContext)
        hotel.name = name
        hotel.rating = rating
        hotel.price = price
        hotel.distance = distance
        hotel.guestCount = Int16(guestCount)
        saveContext()
    }
    
    func deleteHotel(hotel: HotelEntity) {
        persistentContainer.viewContext.delete(hotel)
        saveContext()
    }
}
