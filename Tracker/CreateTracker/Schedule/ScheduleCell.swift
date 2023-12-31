//
//  ScheduleCell.swift
//  Tracker
//

import UIKit

// MARK: - ScheduleCellDelegate
protocol ScheduleCellDelegate: AnyObject {
    func didSwitchChanged(to isOn: Bool, forCellAt index: Int)
}

// MARK: - ScheduleCell
final class ScheduleCell: TitleTableViewCell {

    // MARK: - Public Properties
    static let reuseId = "ScheduleCell"
    weak var delegate: ScheduleCellDelegate?

    // MARK: - Private Properties
    private lazy var switchView: UISwitch = {
        let switchView = UISwitch(frame: .zero)
        switchView.onTintColor = A.Colors.blue.color
        switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        return switchView
    }()

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods
    func configCell(label: String, isOn: Bool, indexPath: IndexPath) {
        super.configCell(label: label)
        switchView.tag = indexPath.row
        switchView.setOn(isOn, animated: false)
        accessoryView = switchView
    }

    // MARK: - Private Methods
    @objc private func switchChanged(_ sender: UISwitch) {
        delegate?.didSwitchChanged(to: sender.isOn, forCellAt: sender.tag)
    }

}
