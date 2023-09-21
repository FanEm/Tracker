//
//  TitleTableViewCell.swift
//  Tracker
//

import UIKit

// MARK: - TitleTableViewCell
class TitleTableViewCell: UITableViewCell {

    // MARK: - Public Properties
    static let reuseIdentifier = "TitleTableViewCell"

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none

        backgroundColor = .trBackground
        separatorInset = GlobalConstants.TableViewCell.separatorInset

        textLabel?.font = GlobalConstants.Font.sfPro17
        textLabel?.textColor = .trBlack
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods
    func configCell(label: String) {
        textLabel?.text = label
    }

}
