//
//  NewTrackerHeaderView.swift
//  Tracker
//

import UIKit

// MARK: - NewTrackerHeaderViewDelegate
protocol NewTrackerHeaderViewDelegate: AnyObject {
    func didChangedTextField(text: String?)
}

// MARK: - NewTrackerHeaderView
final class NewTrackerHeaderView: UICollectionReusableView {

    // MARK: - Public Properties
    static let reuseIdentifier = "NewTrackerHeaderView"
    weak var delegate: NewTrackerHeaderViewDelegate?
    var tableViewCells: [NewTrackerCellType] = [] {
        didSet {
            layoutTableViewHeight()
        }
    }

    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .trWhite
        tableView.register(
            SubtitleTableViewCell.self,
            forCellReuseIdentifier: SubtitleTableViewCell.reuseIdentifier
        )
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .trGray
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: - Private Properties
    private enum Constants {
        static let leadingAndTrailingInsets: CGFloat = 16
        enum TextField {
            static let topInset: CGFloat = 24
            static let height: CGFloat = 75
        }
        enum TableView {
            static let topInset: CGFloat = 24
            static let bottomInset: CGFloat = 32
        }
    }

    private lazy var textField: TextField = {
        let textField = TextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Enter tracker name".localized(),
            attributes: [
                .foregroundColor: UIColor.trGray,
                .font: GlobalConstants.Font.sfPro17 ?? UIFont.systemFont(ofSize: 17)
            ]
        )
        textField.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
        return textField
    }()

    private lazy var tableViewHeightAnchor = {
        self.tableView.heightAnchor.constraint(equalToConstant: 0)
    }()


    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .trWhite
        
        addSubview(textField)
        addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        textField.delegate = self
        
        createDidScheduleOrCategoryChosenObserver()
        
        activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(
                equalTo: topAnchor,
                constant: Constants.TextField.topInset
            ),
            textField.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: Constants.leadingAndTrailingInsets
            ),
            trailingAnchor.constraint(
                equalTo: textField.trailingAnchor,
                constant: Constants.leadingAndTrailingInsets
            ),
            textField.heightAnchor.constraint(
                equalToConstant: Constants.TextField.height
            ),
            tableView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: Constants.leadingAndTrailingInsets
            ),
            trailingAnchor.constraint(
                equalTo: tableView.trailingAnchor,
                constant: Constants.leadingAndTrailingInsets
            ),
            tableView.topAnchor.constraint(
                equalTo: textField.bottomAnchor,
                constant: Constants.TableView.topInset
            ),
            tableViewHeightAnchor,
            bottomAnchor.constraint(
                equalTo: tableView.bottomAnchor,
                constant: Constants.TableView.bottomInset
            )
        ])
    }

    private func layoutTableViewHeight() {
        tableViewHeightAnchor.isActive = false
        tableView.layoutIfNeeded()
        tableView.heightAnchor.constraint(
            equalToConstant: GlobalConstants.TableViewCell.height * CGFloat(tableViewCells.count)
        ).isActive = true
    }

    private func createDidScheduleOrCategoryChosenObserver() {
        return NotificationCenter.default.addObserver(self,
                                                      selector: #selector(reloadTableView),
                                                      name: .didScheduleOrCategoryChosen,
                                                      object: nil)
    }

    private func subLabelOn(_ vc: NewTrackerViewController, for cellType: NewTrackerCellType) -> String? {
        var subLabel: String?
        switch (vc.type, cellType)  {
        case (.event, .category):
            subLabel = vc.category?.name
        case (.event, .schedule):
            subLabel = nil
        case (.habit, .category):
            subLabel = vc.category?.name
        case (.habit, .schedule):
            subLabel = subLabelForSchedule(vc.schedule)
        }
        return subLabel
    }

    private func subLabelForSchedule(_ schedule: Set<WeekDay>) -> String {
        let allWeekDays = WeekDay.allCases
        if schedule == Set(allWeekDays) {
            return "Every day".localized()
        }
        return schedule
            .map { $0.abbreviatedName }
            .reorder(by: allWeekDays.map { $0.abbreviatedName })
            .joined(separator: ", ")
    }

    @objc private func reloadTableView() {
        tableView.reloadData()
    }

    @objc private func textFieldChanged(_ textField: UITextField) {
        delegate?.didChangedTextField(text: textField.text)
    }
    
}

// MARK: - UITableViewDataSource
extension NewTrackerHeaderView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SubtitleTableViewCell.reuseIdentifier,
            for: indexPath
        )
        guard let subtitleTableViewCell = cell as? SubtitleTableViewCell else {
            return UITableViewCell()
        }
        let cellType = tableViewCells[indexPath.row]
        let label = cellType.name
        var subLabel: String? = nil
        if let newTrackerViewController = parentViewController as? NewTrackerViewController {
            subLabel = subLabelOn(newTrackerViewController, for: cellType)
        }
        subtitleTableViewCell.configCell(label: label, subLabel: subLabel)
        subtitleTableViewCell.accessoryType = .disclosureIndicator
        tableView.hideLastSeparator(cell: subtitleTableViewCell, indexPath: indexPath)
        return subtitleTableViewCell
    }
}

// MARK: - UITableViewDelegate
extension NewTrackerHeaderView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let parentViewController else { return }
        let newTrackerViewController = parentViewController as? NewTrackerViewController
        switch tableViewCells[indexPath.row] {
        case .category:
            let viewController = CategoryViewController()
            viewController.delegate = newTrackerViewController
            viewController.selectedCategory = newTrackerViewController?.category
            parentViewController.present(viewController, animated: true)
        case .schedule:
            let viewController = ScheduleViewController()
            viewController.delegate = newTrackerViewController
            viewController.schedule = newTrackerViewController?.schedule ?? []
            parentViewController.present(viewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        GlobalConstants.TableViewCell.height
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        UITableView.addCornerRadiusForFirstAndLastCells(tableView, cell: cell, indexPath: indexPath)
    }
}

// MARK: - UITextFieldDelegate
extension NewTrackerHeaderView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return false
    }
}
