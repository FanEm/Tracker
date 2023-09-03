//
//  NewTrackerBaseView.swift
//  Tracker
//

import UIKit

// MARK: - NewTrackerBaseViewDelegate
protocol NewTrackerBaseViewDelegate: AnyObject {
    func didTapOnColor(_ hexString: String)
    func didTapOnEmoji(_ emoji: String)
}

// MARK: - NewTrackerBaseView
class NewTrackerBaseView: UIView {

    // MARK: - Public Properties
    var tableViewCells: [NewTrackerCellType]
    var title: UILabel = {
        let label = UILabel()
        label.font = GlobalConstants.Font.sfPro16
        label.textColor = .trBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    weak var delegate: NewTrackerBaseViewDelegate?

    // MARK: - Private Properties
    private enum Constants {
        enum CollectionView {
            static let topInset: CGFloat = 14
            static let leadingAndTrailingInsets: CGFloat = 0
            static let itemSize = CGSize(width: 52, height: 52)
            static let sectionInset = UIEdgeInsets(top: 24, left: 18, bottom: 24, right: 18)
        }
    }

    private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.register(
            NewTrackerEmojiViewCell.self,
            forCellWithReuseIdentifier: NewTrackerEmojiViewCell.reuseIdentifier
        )
        collectionView.register(
            NewTrackerColorViewCell.self,
            forCellWithReuseIdentifier: NewTrackerColorViewCell.reuseIdentifier
        )
        collectionView.register(
            BaseSectionTitleView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: BaseSectionTitleView.reuseIdentifier
        )
        collectionView.register(
            NewTrackerHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: NewTrackerHeaderView.reuseIdentifier
        )
        collectionView.register(
            NewTrackerFooterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: NewTrackerFooterView.reuseIdentifier
        )
        collectionView.allowsMultipleSelection = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private let emojies = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]

    private let hexStrings: [String] = [
        "#FD4C49", "#FF881E", "#007BFA", "#6E44FE", "#33CF69", "#E66DD4",
        "#F9D4D4", "#34A7FE", "#46E69D", "#35347C", "#FF674D", "#FF99CC",
        "#F6C48B", "#7994F5", "#832CF1", "#AD56DA", "#8D72E6", "#2FD058"
    ]

    
    // MARK: - Initializers
    init(tableViewCells: [NewTrackerCellType]) {
        self.tableViewCells = tableViewCells
        super.init(frame: .zero)
        backgroundColor = .trWhite

        addSubview(title)
        addSubview(collectionView)

        collectionView.dataSource = self
        collectionView.delegate = self

        activateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(
                equalTo: topAnchor,
                constant: GlobalConstants.Title.inset
            ),
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            collectionView.topAnchor.constraint(
                equalTo: title.bottomAnchor,
                constant: Constants.CollectionView.topInset
            ),
            collectionView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: Constants.CollectionView.leadingAndTrailingInsets
            ),
            trailingAnchor.constraint(
                equalTo: collectionView.trailingAnchor,
                constant: Constants.CollectionView.leadingAndTrailingInsets
            ),
            bottomAnchor.constraint(
                equalTo: collectionView.bottomAnchor
            )
        ])
    }
}


// MARK: - UICollectionViewDataSource
extension NewTrackerBaseView: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        switch section {
        case 1:
            return emojies.count
        case 2:
            return hexStrings.count
        default:
            return 0
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch indexPath.section {
        case 1:
            guard let emojiCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NewTrackerEmojiViewCell.reuseIdentifier,
                for: indexPath
            ) as? NewTrackerEmojiViewCell else { break }
            emojiCell.configCell(emoji: emojies[indexPath.row])
            return emojiCell
        case 2:
            guard let colorCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NewTrackerColorViewCell.reuseIdentifier,
                for: indexPath
            ) as? NewTrackerColorViewCell else { break }
            colorCell.configCell(hexString: hexStrings[indexPath.row])
            return colorCell
        default:
            break
        }
        return UICollectionViewCell()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
}

// MARK: - UICollectionViewDelegate
extension NewTrackerBaseView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            delegate?.didTapOnEmoji(emojies[indexPath.row])
        case 2:
            delegate?.didTapOnColor(hexStrings[indexPath.row])
        default:
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        collectionView.indexPathsForSelectedItems?
            .filter { $0.section == indexPath.section }
            .forEach { collectionView.deselectItem(at: $0, animated: false) }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        guard let item = collectionView.cellForItem(at: indexPath) else { return false }
        return !item.isSelected
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let section = indexPath.section
        let reusableView = UICollectionReusableView()
        let newTrackerViewController = parentViewController as? NewTrackerViewController
        let newTrackerPresenter = newTrackerViewController?.presenter
        if kind == UICollectionView.elementKindSectionHeader {
            guard let sectionTitleView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: BaseSectionTitleView.reuseIdentifier,
                for: indexPath
            ) as? BaseSectionTitleView else { return reusableView }
            switch section {
            case 0:
                guard let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: NewTrackerHeaderView.reuseIdentifier,
                    for: indexPath
                ) as? NewTrackerHeaderView else { break }
                headerView.delegate = newTrackerPresenter as? any NewTrackerHeaderViewDelegate
                headerView.tableViewCells = tableViewCells
                return headerView
            case 1:
                sectionTitleView.titleLabel.text = "Emoji".localized()
                return sectionTitleView
            case 2:
                sectionTitleView.titleLabel.text = "Color".localized()
                return sectionTitleView
            default:
                break
            }
            return reusableView
        }
        if kind == UICollectionView.elementKindSectionFooter,
            section == 3
        {
            guard let footerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: NewTrackerFooterView.reuseIdentifier,
                for: indexPath
            ) as? NewTrackerFooterView else { return reusableView }
            footerView.delegate = newTrackerViewController
            newTrackerPresenter?.checkIfAllFieldsFilled()
            return footerView
        }
        return reusableView
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension NewTrackerBaseView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return Constants.CollectionView.itemSize
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 1, 2:
            return Constants.CollectionView.sectionInset
        default:
            return UIEdgeInsets()
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt: Int
    ) -> CGFloat {
        return 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        getReferenceSize(
            collectionView: collectionView,
            section: section,
            kind: UICollectionView.elementKindSectionHeader
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int
    ) -> CGSize {
        getReferenceSize(
            collectionView: collectionView,
            section: section,
            kind: UICollectionView.elementKindSectionFooter
        )
    }
    
    func getReferenceSize(collectionView: UICollectionView, section: Int, kind: String) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let view = self.collectionView(
            collectionView,
            viewForSupplementaryElementOfKind: kind,
            at: indexPath
        )
        return view.systemLayoutSizeFitting(
            CGSize(width: collectionView.frame.width,
                   height: UIView.layoutFittingExpandedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
}
