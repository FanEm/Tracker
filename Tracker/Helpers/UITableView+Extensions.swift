//
//  UITableView+Extensions.swift
//  Tracker
//

import UIKit

extension UITableView {

    /// Calculates the last cell index path if available
    var lastCellIndexPath: IndexPath? {
        for section in (0..<self.numberOfSections).reversed() {
            let rows = numberOfRows(inSection: section)
            guard rows > 0 else { continue }
            return IndexPath(row: rows - 1, section: section)
        }
        return nil
    }

    func hideLastSeparator(cell: UITableViewCell, indexPath: IndexPath) {
        let insetToHide = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: self.bounds.width + 1)
        let inset = GlobalConstants.TableViewCell.separatorInset
        cell.separatorInset = indexPath == lastCellIndexPath ? insetToHide : inset
    }

    static func addCornerRadiusForFirstAndLastCells(
        _ tableView: UITableView,
        cell: UITableViewCell,
        indexPath: IndexPath,
        cornerRadius: CGFloat = GlobalConstants.cornerRadius
    ) {
        cell.layer.masksToBounds = true
        if tableView.numberOfRows(inSection: indexPath.section) == 1 {
            cell.layer.cornerRadius = cornerRadius
            cell.layer.maskedCorners = MaskedCorners.all
            return
        }

        switch indexPath.row {
        case 0:
            cell.layer.cornerRadius = cornerRadius
            cell.layer.maskedCorners = MaskedCorners.top
        case tableView.numberOfRows(inSection: indexPath.section) - 1:
            cell.layer.cornerRadius = cornerRadius
            cell.layer.maskedCorners = MaskedCorners.bottom
        default:
            cell.layer.cornerRadius = 0
        }
    }

    private enum MaskedCorners {
        static let top: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        static let bottom: CACornerMask = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        static let all: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner,
                                        .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }

}
