//
//  HotelFilterViewController.swift
//  MegafonTest
//
//  Created by Ботурбек Имомдодов on 25/01/25.
//

import UIKit
import RxSwift
import RxCocoa

class HotelFilterViewController: UIViewController {
    private let viewModel: HotelSearchViewModel
    private let disposeBag = DisposeBag()
    
    private let priceFilterSlider: FilterSlider
    private let ratingFilterSlider: FilterSlider
    private let distanceFilterSlider: FilterSlider
    
    private let applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Apply", for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            priceFilterSlider,
            ratingFilterSlider,
            distanceFilterSlider,
            applyButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupBindings() {
        applyButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                var currentFilter = viewModel.filter.value
                currentFilter.priceRange = priceFilterSlider.slider.value
                currentFilter.rating = self.ratingFilterSlider.slider.value
                currentFilter.distance = self.distanceFilterSlider.slider.value
                self.viewModel.filter.accept(currentFilter)
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
