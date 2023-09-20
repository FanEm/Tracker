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
        let tableView = BaseTableView()
        tableView.register(
            SubtitleTableViewCell.self,
            forCellReuseIdentifier: SubtitleTableViewCell.reuseIdentifier
        )
        return tableView
    }()

    // MARK: - Private Properties
    private enum Constants {
        static let leadingAndTrailingInsets: CGFloat = 16
        enum TextField {
            static let topInset: CGFloat = 24
            static let height: CGFloat = 75
        }
        enum ErrorLabel {
            static let height: CGFloat = 30
        }
        enum TableView {
            static let topInset: CGFloat = 24
            static let bottomInset: CGFloat = 32
        }
    }

    private lazy var textField: TextField = {
        let textField = TextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: L.NewTracker.TextField.placeholder,
            attributes: [
                .foregroundColor: UIColor.trGray,
                .font: GlobalConstants.Font.sfPro17 ?? UIFont.systemFont(ofSize: 17)
            ]
        )
        textField.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
        textField.becomeFirstResponder()
        return textField
    }()

    private var errorLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = L.NewTracker.TextField.charLimit(GlobalConstants.TextField.maxLength)
        label.font = GlobalConstants.Font.sfPro17
        label.isHidden = true
        label.textAlignment = .center
        label.textColor = .trRed
        label.numberOfLines = 1
        return label
    }()

    private lazy var tableViewHeightAnchor = {
        self.tableView.heightAnchor.constraint(equalToConstant: 0)
    }()

    private lazy var labelHeightAnchor = {
        self.errorLabel.heightAnchor.constraint(equalToConstant: 0)
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .trWhite

        addSubview(textField)
        addSubview(errorLabel)
        addSubview(tableView)

        tableView.dataSource = self
        tableView.delegate = self
        textField.delegate = self

        registerDidScheduleOrCategoryChosenObserver()
        activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods
    func configure(
        delegate: NewTrackerHeaderViewDelegate?,
        textFieldText: String,
        tableViewCells: [NewTrackerCellType]
    ) {
        self.delegate = delegate
        self.tableViewCells = tableViewCells
        textField.text = textFieldText
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

            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: errorLabel.trailingAnchor),
            errorLabel.topAnchor.constraint(equalTo: textField.bottomAnchor),
            labelHeightAnchor,
            
            tableView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: Constants.leadingAndTrailingInsets
            ),
            trailingAnchor.constraint(
                equalTo: tableView.trailingAnchor,
                constant: Constants.leadingAndTrailingInsets
            ),
            tableView.topAnchor.constraint(
                equalTo: errorLabel.bottomAnchor,
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
        tableViewHeightAnchor.constant = GlobalConstants.TableViewCell.height * CGFloat(tableViewCells.count)
        tableView.reloadData()
    }

    private func registerDidScheduleOrCategoryChosenObserver() {
        return NotificationCenter.default.addObserver(self,
                                                      selector: #selector(reloadTableView),
                                                      name: .didScheduleOrCategoryChosen,
                                                      object: nil)
    }

    private func getSubLabel(model: NewTrackerModel, cellType: NewTrackerCellType) -> String? {
        var subLabel: String?
        switch (model.type, cellType)  {
        case (.event, .category):
            subLabel = model.category?.name
        case (.event, .schedule):
            subLabel = nil
        case (.habit, .category):
            subLabel = model.category?.name
        case (.habit, .schedule):
            subLabel = subLabelForSchedule(model.schedule)
        }
        return subLabel
    }

    private func subLabelForSchedule(_ schedule: Set<WeekDay>) -> String {
        let allWeekDays = WeekDay.allCases
        if schedule == Set(allWeekDays) {
            return L.WeekDay.everyDay
        }
        return schedule
            .map { $0.abbreviatedName }
            .reorder(by: allWeekDays.map { $0.abbreviatedName })
            .joined(separator: ", ")
    }
    
    private func showErrorLabelIfNeeded(text: String?) {
        guard let text else { return }
        let isHidden = text.count <= GlobalConstants.TextField.maxLength
        guard errorLabel.isHidden != isHidden else { return }
        labelHeightAnchor.constant = isHidden ? 0 : Constants.ErrorLabel.height
        UIView.transition(with: errorLabel, duration: 0.3) { [weak self] in
            guard let self else { return }
            self.layoutIfNeeded()
            self.errorLabel.isHidden = isHidden
        }
        NotificationCenter.default.post(name: .didErrorLabelChangeState, object: isHidden)
    }

    @objc private func reloadTableView() {
        tableView.reloadData()
    }

    @objc private func textFieldChanged(_ textField: UITextField) {
        let text = textField.text
        delegate?.didChangedTextField(text: text)
        showErrorLabelIfNeeded(text: text)
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
        if let newTrackerViewController = parentViewController as? NewTrackerViewController,
           let model = newTrackerViewController.presenter?.newTrackerModel {
            subLabel = getSubLabel(model: model, cellType: cellType)
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
        let newTrackerPresenter = newTrackerViewController?.presenter
        switch tableViewCells[indexPath.row] {
        case .category:
            let categoryViewModel = CategoryViewModel()
            let viewController = CategoryViewController(categoryViewModel: categoryViewModel)
            viewController.delegate = newTrackerPresenter as? any CategoryViewControllerDelegate
            categoryViewModel.selectedCategory = newTrackerPresenter?.newTrackerModel.category
            parentViewController.present(viewController, animated: true)
        case .schedule:
            let viewController = ScheduleViewController()
            viewController.delegate = newTrackerPresenter as? any ScheduleViewControllerDelegate
            viewController.schedule = newTrackerPresenter?.newTrackerModel.schedule ?? []
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
