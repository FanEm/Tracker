//
//  TrackersView.swift
//  Tracker
//

import UIKit

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
        collectionView.backgroundColor = A.Colors.whiteDynamic.color
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
            static let edgeInsets = UIEdgeInsets(top: 14, left: 20, bottom: 14, right: 20)
        }
    }

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = A.Colors.whiteDynamic.color
        addSubview(collectionView)
        activateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            )
        ])
    }

}
