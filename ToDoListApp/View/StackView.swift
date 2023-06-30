//
//  StackView.swift
//  ToDoListApp
//
//  Created by Судур Сугунушев on 25.06.2023.
//

import Foundation
import UIKit

final class StackView {

    let importanceRow = UIView()
    let dateRow = UIView()
    let dateSwitch = UISwitch()

    let stack = UIStackView()

    func setStackView() -> UIStackView {
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.spacing = 0

        stack.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        createImportanceRow()
        createDeadlineRow()
        stack.addArrangedSubview(importanceRow)
        stack.addArrangedSubview(createSeparator())
        stack.addArrangedSubview(dateRow)

        return stack

    }

    func createSeparator() -> UIView{
        let separator = UIView()
        separator.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)

        separator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 1.0 / UIScreen.main.scale),
        ])
        return separator
    }

    func createDeadlineRow() {
        let deadlineLabel = UILabel()
        deadlineLabel.text = "Сделать до"
        deadlineLabel.font = UIFont(name: "GeezaPro", size: 17)

        let deadlineDate = UIButton(type: .roundedRect)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d MMMM yyyy"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone


        deadlineDate.setTitle(dateFormatter.string(from: Date(timeInterval: 86400, since: Date())),
                              for: .normal)
        deadlineDate.setTitleColor(UIColor(red: 0, green: 122 / 255, blue: 1, alpha: 1),
                                   for: .normal)
        deadlineDate.titleLabel?.font = UIFont(name: "GeezaPro", size: 13)
        deadlineDate.addTarget(self, action: #selector(openCalendar), for: .allEvents)


        dateRow.addSubview(deadlineLabel)
        dateRow.addSubview(dateSwitch)

        dateRow.translatesAutoresizingMaskIntoConstraints = false
        deadlineLabel.translatesAutoresizingMaskIntoConstraints = false
        dateSwitch.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateSwitch.topAnchor.constraint(equalTo: dateRow.topAnchor, constant: 12.5),
            dateSwitch.trailingAnchor.constraint(equalTo: dateRow.trailingAnchor, constant: -12.5),
            dateSwitch.bottomAnchor.constraint(equalTo: dateRow.bottomAnchor, constant: -12.5),])

        dateSwitch.isOn = true
        if !dateSwitch.isOn {
            NSLayoutConstraint.activate([
                deadlineLabel.topAnchor.constraint(equalTo: dateRow.topAnchor, constant: 17),
                deadlineLabel.bottomAnchor.constraint(equalTo: dateRow.bottomAnchor, constant: -17),
                deadlineLabel.leadingAnchor.constraint(equalTo: dateRow.leadingAnchor, constant: 16),
            ])
        } else {
            dateRow.addSubview(deadlineDate)

            deadlineDate.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                deadlineLabel.topAnchor.constraint(equalTo: dateRow.topAnchor, constant: 8),
                deadlineLabel.heightAnchor.constraint(equalToConstant: 22),
                deadlineLabel.leadingAnchor.constraint(equalTo: dateRow.leadingAnchor, constant: 16),

                deadlineDate.heightAnchor.constraint(equalToConstant: 18),
                deadlineDate.bottomAnchor.constraint(equalTo: dateRow.bottomAnchor, constant: -8),
                deadlineDate.leadingAnchor.constraint(equalTo: dateRow.leadingAnchor, constant: 16)
            ])
        }
    }

    func createImportanceRow() {
        let importanceLabel = UILabel()
        importanceLabel.text = "Важность"
        var segmentsArray = [Any]()

        if let notImportant = UIImage(systemName: "arrow.down") {
            segmentsArray.append(notImportant.withRenderingMode(.alwaysOriginal))
        }
        segmentsArray.append("нет")
        if let important = UIImage(systemName: "exclamationmark.2") {
            segmentsArray.append(important.withRenderingMode(.alwaysOriginal))
        }

        let importanceSegmControl = UISegmentedControl(items: segmentsArray)
        importanceSegmControl.selectedSegmentIndex = 2
        importanceSegmControl.layer.cornerRadius = 9

        importanceRow.addSubview(importanceLabel)
        importanceRow.addSubview(importanceSegmControl)

        importanceLabel.font = UIFont(name: "GeezaPro", size: 17)
        importanceRow.translatesAutoresizingMaskIntoConstraints = false
        importanceLabel.translatesAutoresizingMaskIntoConstraints = false
        importanceSegmControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            importanceRow.heightAnchor.constraint(equalToConstant: 56),
            importanceLabel.topAnchor.constraint(equalTo: importanceRow.topAnchor, constant: 17),
            importanceLabel.leadingAnchor.constraint(equalTo: importanceRow.leadingAnchor, constant: 16),

            importanceLabel.bottomAnchor.constraint(equalTo: importanceRow.bottomAnchor, constant: -17),
            importanceSegmControl.topAnchor.constraint(equalTo: importanceRow.topAnchor, constant: 10),
            importanceSegmControl.trailingAnchor.constraint(equalTo: importanceRow.trailingAnchor, constant: -12),
            importanceSegmControl.bottomAnchor.constraint(equalTo: importanceRow.bottomAnchor, constant: -10),
            importanceSegmControl.heightAnchor.constraint(equalToConstant: 36),
            importanceSegmControl.widthAnchor.constraint(equalToConstant: 150)
        ])
    }

     @objc func openCalendar(sender: UIButton) {
         let calendarView = UICalendarView()
         let gregorianCalendar = Calendar(identifier: .gregorian)
         calendarView.calendar = gregorianCalendar
         calendarView.locale = Locale(identifier: "ru_RU")
         calendarView.fontDesign = .default
         let separator = createSeparator()
         stack.addArrangedSubview(calendarView)
         calendarView.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: dateRow.bottomAnchor),
            calendarView.heightAnchor.constraint(equalToConstant: 332),
            calendarView.widthAnchor.constraint(equalToConstant: 343)
         ])
    }
}

