//
//  OnboardingViewController.swift
//  Tracker
//

import UIKit


// MARK: - OnboardingViewController
final class OnboardingViewController: UIViewController {

    // MARK: - Private Properties
    private let image: UIImage
    private let text: String

    private enum Constants {
        static let fontSize: CGFloat = 32

        enum Label {
            static let leadingAndTrailingInset: CGFloat = 16
        }

        enum Button {
            static let leadingAndTrailingInset: CGFloat = 20
            static let bottomInset: CGFloat = 50
        }
    }

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .trPermBlack
        label.font = .sfPro(ofSize: Constants.fontSize, withStyle: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var button: UIButton = {
        let button = BaseButton()
        button.backgroundColor = .trPermBlack
        button.setTitleColor(.trPermWhite, for: .normal)
        button.setTitle("What a technology".localized(), for: .normal)
        button.addTarget(self, action: #selector(onTap), for: .touchUpInside)
        return button
    }()

    // MARK: - Initializers
    init(image: UIImage, text: String) {
        self.image = image
        self.text = text
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(imageView)
        view.addSubview(label)
        view.addSubview(button)

        activateConstraints()
    }

    // MARK: - Private Methods
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),

            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constants.Label.leadingAndTrailingInset
            ),
            view.trailingAnchor.constraint(
                equalTo: label.trailingAnchor,
                constant: Constants.Label.leadingAndTrailingInset
            ),

            button.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constants.Button.leadingAndTrailingInset
            ),
            view.trailingAnchor.constraint(
                equalTo: button.trailingAnchor,
                constant: Constants.Button.leadingAndTrailingInset
            ),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(
                equalTo: button.bottomAnchor,
                constant:  Constants.Button.bottomInset
            )
        ])
    }

    @objc private func onTap() {
        dismiss(animated: true)
    }

}
