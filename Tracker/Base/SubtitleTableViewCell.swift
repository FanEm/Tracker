//
//  SubtitleTableViewCell.swift
//  Tracker
//

import UIKit

// MARK: - SubtitleTableViewCell
class SubtitleTableViewCell: UITableViewCell {
    static let reuseIdentifier = "SubtitleTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none

        backgroundColor = .trBackground
        separatorInset = GlobalConstants.TableViewCell.separatorInset
        
        textLabel?.font = GlobalConstants.Font.sfPro17
        textLabel?.textColor = .trBlack
        
        detailTextLabel?.font = GlobalConstants.Font.sfPro17
        detailTextLabel?.textColor = .trGray
    }
    
    func configCell(label: String, subLabel: String?) {
        textLabel?.text = label
        detailTextLabel?.text = subLabel
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
