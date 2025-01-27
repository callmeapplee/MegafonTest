//
//  HotelFilterViewController.swift
//  MegafonTest
//
//  Created by Ботурбек Имомдодов on 25/01/25.
//

import UIKit

class HotelFilterViewController: UIViewController {
    private let viewModel: HotelSearchViewModel

    private let priceFilterSlider: FilterSlider
    private let ratingFilterSlider: FilterSlider
    private let distanceFilterSlider: FilterSlider
    
    private let checkInPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.minimumDate = Date()
        return picker
    }()
    
    private let checkOutPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.minimumDate = Date()
        return picker
    }()
    
    private let applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Apply", for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            priceFilterSlider,
            ratingFilterSlider,
            distanceFilterSlider,
            createPickerView(title: "Check-in Date", picker: checkInPicker),
            createPickerView(title: "Check-out Date (Optional)", picker: checkOutPicker),
            applyButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    init(viewModel: HotelSearchViewModel) {
        self.viewModel = viewModel
        
        self.priceFilterSlider = FilterSlider(
            title: "Price Range",
            step: 100,
            minValue: 0,
            maxValue: 1000,
            value: viewModel.filter.value.priceRange,
            valueFormat: "$%.0f"
        )
        self.ratingFilterSlider = FilterSlider(
            title: "Rating",
            step: 0.5,
            minValue: 0,
            maxValue: 5,
            value: viewModel.filter.value.rating,
            valueFormat: "%.1f★"
        )
        self.distanceFilterSlider = FilterSlider(
            title: "Distance",
            step: 1,
            minValue: 0,
            maxValue: 20,
            value: viewModel.filter.value.distance,
            valueFormat: "%.0f km"
        )
        
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
        title = "Filters"
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupBindings() {
        applyButton.addTarget(self, action: #selector(applyFilters), for: .touchUpInside)
        checkInPicker.addTarget(self, action: #selector(updateCheckOutMinimumDate), for: .valueChanged)
    }
    
    private func createPickerView(title: String, picker: UIDatePicker) -> UIView {
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        
        let stackView = UIStackView(arrangedSubviews: [label, picker])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .fill
        return stackView
    }
    
    @objc private func applyFilters() {
        var currentFilter = viewModel.filter.value
        currentFilter.priceRange = priceFilterSlider.slider.value
        currentFilter.rating = ratingFilterSlider.slider.value
        currentFilter.distance = distanceFilterSlider.slider.value
        currentFilter.checkInDate = checkInPicker.date
        currentFilter.checkOutDate = checkOutPicker.date
        viewModel.filter.value = currentFilter
        dismiss(animated: true)
    }
    
    @objc private func updateCheckOutMinimumDate() {
        checkOutPicker.minimumDate = checkInPicker.date
    }
}
