//
//  SubtitleTableViewCell.swift
//  Tracker
//

import UIKit

// MARK: - SubtitleTableViewCell
class SubtitleTableViewCell: UITableViewCell {

    // MARK: - Public Properties
    static let reuseIdentifier = "SubtitleTableViewCell"

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none

        backgroundColor = A.Colors.backgroundDynamic.color
        separatorInset = GlobalConstants.TableViewCell.separatorInset

        textLabel?.font = GlobalConstants.Font.sfPro17
        textLabel?.textColor = A.Colors.blackDynamic.color

        detailTextLabel?.font = GlobalConstants.Font.sfPro17
        detailTextLabel?.textColor = A.Colors.gray.color
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods
    func configCell(label: String, subLabel: String?) {
        textLabel?.text = label
        detailTextLabel?.text = subLabel
    }

}
