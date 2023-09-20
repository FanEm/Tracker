//
//  StatisticsTableViewCell.swift
//  Tracker
//

import UIKit


// MARK: - StatisticsTableViewCell
final class StatisticsTableViewCell: UITableViewCell {

    // MARK: - Public Properties
    static let reuseIdentifier = "StatisticsTableViewCell"

    // MARK: - Private Properties
    private enum Constants {
        enum Label {
            static let inset: CGFloat = 12
            enum FontSize {
                static let count: CGFloat = 34
                static let title: CGFloat = 12
            }
        }
        enum View {
            static let leadingAndTrailingInset: CGFloat = 16
            static let bottomInset: CGFloat = 12
        }
    }

    private let view: UIView = {
        let view = UIView()
        view.backgroundColor = .trWhite
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .sfPro(
            ofSize: Constants.Label.FontSize.count,
            withStyle: .bold
        )
        label.textColor = .trBlack
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .sfPro(ofSize: Constants.Label.FontSize.title)
        label.textColor = .trBlack
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var gradient: CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: CGPoint.zero, size: view.frame.size)
        gradient.startPoint = CGPoint(x: 1, y: 0.5)
        gradient.endPoint = CGPoint(x: 0, y: 0.5)
        gradient.colors = [
            UIColor.trGradientBlue.cgColor,
            UIColor.trGradientGreen.cgColor,
            UIColor.trGradientRed.cgColor
        ]

        let shape = CAShapeLayer()
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = UIColor.white.cgColor
        shape.lineWidth = 2
        shape.path = UIBezierPath(
            roundedRect: view.bounds,
            cornerRadius: view.layer.cornerRadius
        ).cgPath

        gradient.mask = shape
        return gradient
    }

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
        activateConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides Methods
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        view.layer.addSublayer(gradient)
    }

    // MARK: - Public Methods
    func configCell(title: String, count: Int) {
        titleLabel.text = title
        countLabel.text = "\(count)"
    }

    // MARK: - Private Methods
    private func setupUI() {
        contentView.addSubview(view)
        view.addSubview(countLabel)
        view.addSubview(titleLabel)
        view.layer.cornerRadius = GlobalConstants.cornerRadius
        view.layer.masksToBounds = true

        selectionStyle = .none
        backgroundColor = .trWhite
    }

    private func activateConstraints() {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constants.View.leadingAndTrailingInset
            ),
            contentView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: Constants.View.leadingAndTrailingInset
            ),
            contentView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: Constants.View.bottomInset
            ),
            
            countLabel.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: Constants.Label.inset
            ),
            countLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constants.Label.inset
            ),
            view.trailingAnchor.constraint(
                equalTo: countLabel.trailingAnchor,
                constant: Constants.Label.inset
            ),

            titleLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constants.Label.inset
            ),
            view.trailingAnchor.constraint(
                equalTo: titleLabel.trailingAnchor,
                constant: Constants.Label.inset
            ),
            view.bottomAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: Constants.Label.inset
            ),
        ])
    }

}
