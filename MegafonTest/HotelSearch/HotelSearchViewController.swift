//
//  ViewController.swift
//  MegafonTest
//
//  Created by Ботурбек Имомдодов on 25/01/25.
//

import UIKit

class HotelSearchViewController: UIViewController {
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let filterButton = UIBarButtonItem(title: "Filters", style: .plain, target: nil, action: nil)
    private let viewModel = HotelSearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        title = "Hotels"
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HotelCell")
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
        navigationItem.rightBarButtonItem = filterButton
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupBindings() {
        viewModel.filteredHotels.bind { [weak self] hotels in
            self?.tableView.reloadData()
        }
        
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        filterButton.target = self
        filterButton.action = #selector(filterButtonTapped)
    }
    
    @objc private func filterButtonTapped() {
        let filterVC = HotelFilterViewController(viewModel: viewModel)
        let navController = UINavigationController(rootViewController: filterVC)
        present(navController, animated: true)
    }
}

extension HotelSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var currentFilter = viewModel.filter.value
        currentFilter.searchQuery = searchText
        viewModel.filter.value = currentFilter
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension HotelSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredHotels.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HotelCell", for: indexPath)
        let hotel = viewModel.filteredHotels.value[indexPath.row]
        cell.textLabel?.text = "\(hotel.name) - $\(hotel.price) - \(hotel.rating)★ - \(hotel.distance)km"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedHotel = viewModel.filteredHotels.value[indexPath.row]
        let detailViewModel = HotelDetailViewModel(booking: viewModel.getBooking(by: selectedHotel))
        let detailVC = HotelDetailViewController(viewModel: detailViewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
