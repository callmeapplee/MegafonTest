//
//  FilterSlider.swift
//  MegafonTest
//
//  Created by Ботурбек Имомдодов on 26/01/25.
//

import UIKit
import RxSwift
import RxCocoa

class FilterSlider: UIView {
    
    private let step: Float
    private let valueFormat: String
    
    let slider: UISlider = {
        let slider = UISlider()
        return slider
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let disposeBag = DisposeBag()
    
    init(
        title: String,
        step: Float,
        minValue: Float,
        maxValue: Float,
        value: Float?,
        valueFormat: String = ""
    ) {
        self.step = step
        self.valueFormat = valueFormat
        super.init(frame: .zero)
        
        setupUI()
        setupBindings()
        
        titleLabel.text = title
        slider.minimumValue = minValue
        slider.maximumValue = maxValue
        slider.setValue(value ?? 0, animated: true)
        valueLabel.text = String(format: valueFormat, slider.value)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, slider, valueLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private func setupUI() {
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupBindings() {
        slider.rx.value
            .bind { [weak self] value in
                guard let self = self else { return }
                let formattedValue = round(value / self.step) * self.step
                slider.value = formattedValue
                valueLabel.text = String(format: valueFormat, formattedValue)
            }
            .disposed(by: disposeBag)
    }
}
