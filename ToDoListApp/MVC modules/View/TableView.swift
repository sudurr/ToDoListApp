//
//  TableView.swift
//  ToDoListApp
//
//  Created by Судур Сугунушев on 30.06.2023.
//

import UIKit

class DefaultTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

class ImportantTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

class DeadlineTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

class BothTableViewCell: UITableViewCell {
    
    static let identifier = "BothViewsCell"
    
    let imageCheckSwipe = UIImage(
        systemName: "checkmark.circle.fill",
        withConfiguration: UIImage.SymbolConfiguration(
            paletteColors: [.systemGreen, .white]))
    
    let dateLabel: UILabel = {
        
        let label = UILabel()
        
        label.text = "March 6, 2024"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.textColor = UIColor(named: "LabelTertiary")
        
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        dateLabel.text = nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        
        titleLabelSetup()
    }
    
    func titleLabelSetup() {
        titleLabel.leadingAnchor.constraint(equalTo: imageView!.trailingAnchor, constant: contentView.frame.width/20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -10).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func dateLabelSetup() {
        dateLabel.leadingAnchor.constraint(equalTo: imageView!.trailingAnchor, constant: contentView.frame.width/20).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -10).isActive = true
        dateLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 10).isActive = true
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
    }
}

