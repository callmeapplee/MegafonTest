//
//  ViewController.swift
//  MegafonTest
//
//  Created by Ботурбек Имомдодов on 25/01/25.
//

import UIKit
import RxSwift
import RxCocoa

class HotelSearchViewController: UIViewController {
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let filterButton = UIBarButtonItem(title: "Filters", style: .plain, target: nil, action: nil)
    private let viewModel = HotelSearchViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        title = "Hotels"
        view.backgroundColor = .white
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        navigationItem.rightBarButtonItem = filterButton
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HotelCell")
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: -8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
        ])
    }
    
    private func setupBindings() {
        searchBar.rx.text.orEmpty
            .bind { [weak self] query in
                guard let self = self else { return }
                var currentFilter = self.viewModel.filter.value
                currentFilter.searchQuery = query
                viewModel.filter.accept(currentFilter)
            }
            .disposed(by: disposeBag)
        
        viewModel.filteredHotels
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "HotelCell", cellType: UITableViewCell.self)) { _, hotel, cell in
                cell.textLabel?.text = "\(hotel.name) - $\(hotel.price) - \(hotel.rating)★ - \(hotel.distance)km"
            }
            .disposed(by: disposeBag)
        
        filterButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                let filterVC = HotelFilterViewController(viewModel: viewModel)
                let navController = UINavigationController(rootViewController: filterVC)
                present(navController, animated: true)
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .bind { [weak self] in
                guard let self = self else { return }
                searchBar.resignFirstResponder()
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Hotel.self)
            .bind { [weak self] selectedHotel in
                guard let self = self else { return }
                let hotelDetailViewController = HotelDetailViewController(viewModel: HotelDetailViewModel(booking: selectedHotel.booking))
                navigationController?.pushViewController(hotelDetailViewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
