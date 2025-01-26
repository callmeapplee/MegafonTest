//
//  BookingViewController.swift
//  MegafonTest
//
//  Created by Ботурбек Имомдодов on 26/01/25.
//

import UIKit
import RxSwift
import RxCocoa

class BookingViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchBookings()
    }
    
    private let viewModel = BookingViewModel()
    private let disposeBag = DisposeBag()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BookingCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        title = "Booking"
        
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupBindings() {
        viewModel.bookings
            .bind(to: tableView.rx.items(cellIdentifier: "BookingCell")) { (row, booking, cell) in
                cell.textLabel?.text = "Hotel: \(booking.name) - Guests: \(booking.guestCount)"
            }
            .disposed(by: disposeBag)
        tableView.rx.modelSelected(Booking.self)
            .subscribe(onNext: { [weak self] booking in
                guard let self = self else { return }
                let viewController = HotelDetailViewController(viewModel: HotelDetailViewModel(booking: booking))
                navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
        tableView.rx.itemDeleted
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                self.viewModel.deleteBooking(at: indexPath.row)
            })
            .disposed(by: disposeBag)
    }
}
