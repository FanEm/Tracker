//
//  TrackersView.swift
//  Tracker
//

import UIKit
import Foundation


// MARK: - TrackersView
final class TrackersView: UIView {

    // MARK: - Public Properties
    var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.register(
            TrackerCollectionViewCell.self,
            forCellWithReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier
        )
        collectionView.register(
            BaseSectionTitleView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: BaseSectionTitleView.reuseIdentifier
        )
        collectionView.contentInset = Constants.CollectionView.contentInset
        collectionView.backgroundColor = .trWhite
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    // MARK: - Private Properties
    private enum Constants {
        enum CollectionView {
            static let bottomContentInset = Constants.Button.edgeInsets.bottom
                                          + Constants.Button.edgeInsets.top
                                          + GlobalConstants.Font.sfPro17!.lineHeight
            static let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomContentInset, right: 0)
        }
        enum Button {
            static let bottomInset: CGFloat = 16
            static let edgeInsets = UIEdgeInsets(top: 14, left: 20, bottom: 14, right: 20)
        }
    }

    private lazy var button: UIButton = {
        let button = BaseButton()
        button.setTitleColor(.trPermWhite, for: .normal)
        button.titleLabel?.font = GlobalConstants.Font.sfPro17
        button.setTitle("Filters".localized(), for: .normal)
        button.backgroundColor = .trBlue
        button.addTarget(self, action: #selector(tapFiltersButton), for: .touchUpInside)
        return button
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .trWhite
        addSubview(collectionView)
        addSubview(button)
        activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods
    func showFilterButton(_ show: Bool) {
        button.isHidden = !show
    }

    // MARK: - Private Methods
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            collectionView.topAnchor.constraint(
                equalTo: topAnchor
            ),
            trailingAnchor.constraint(
                equalTo: collectionView.trailingAnchor
            ),
            bottomAnchor.constraint(
                equalTo: collectionView.bottomAnchor
            ),
            
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            bottomAnchor.constraint(
                equalTo: button.bottomAnchor,
                constant: Constants.Button.bottomInset
            )
        ])
    }

    @objc private func tapFiltersButton() {
        guard let parentViewController else { return }
        let viewController = FiltersViewController()
        parentViewController.present(viewController, animated: true)
    }
}
