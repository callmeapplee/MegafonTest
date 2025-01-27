//
//  HotelDetailViewController.swift
//  MegafonTest
//
//  Created by Ботурбек Имомдодов on 26/01/25.
//

import UIKit
import Kingfisher

class HotelDetailViewController: UIViewController {
    private let viewModel: HotelDetailViewModel

    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: .init(origin: .zero, size: .init(width: 200, height: 200)))
        return imageView
    }()

    private let hotelNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let guestCountStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 1
        stepper.maximumValue = 10
        stepper.translatesAutoresizingMaskIntoConstraints = false
        return stepper
    }()

    private let guestCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var bookButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 8
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            hotelNameLabel,
            ratingLabel,
            priceLabel,
            distanceLabel,
            guestCountLabel,
            guestCountStepper,
            bookButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    init(viewModel: HotelDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func setupBindings() {
        viewModel.booking.bind { [weak self] booking in
            guard let self = self else { return }
            hotelNameLabel.text = booking.name
            ratingLabel.text = "Rating: \(booking.rating)"
            priceLabel.text = "$\(booking.price) per night"
            distanceLabel.text = "Distance: \(booking.distance) km from center"
            guestCountStepper.value = Double(booking.guestCount)
            guestCountLabel.text = "Guests: \(booking.guestCount)"
            imageView.kf.setImage(with: booking.image)
            bookButton.setTitle(booking.isBooked ? "Update" : "Book Now", for: .normal)
        }

        guestCountStepper.addTarget(self, action: #selector(guestCountChanged(_:)), for: .valueChanged)

        bookButton.addTarget(self, action: #selector(bookButtonTapped), for: .touchUpInside)
    }

    @objc private func guestCountChanged(_ sender: UIStepper) {
        guestCountLabel.text = "Guests: \((Int(sender.value)))"

        var currentBooking = viewModel.booking.value
        currentBooking.guestCount = Int(sender.value)
        viewModel.booking.value = currentBooking
    }

    @objc private func bookButtonTapped() {
        viewModel.book()
    }
}
