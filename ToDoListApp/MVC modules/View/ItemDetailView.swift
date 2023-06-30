//
//  ItemDetailView.swift
//  ToDoListApp
//
//  Created by Судур Сугунушев on 30.06.2023.
//

import UIKit

class DetailsTextView: UITextView {
    
    let placeholder = "Что надо сделать?"
    
    private func textViewInit() {
        
        text = placeholder
        textColor = UIColor(named: "LabelTertiary")
        font = .systemFont(ofSize: 18, weight: .light)
        
        backgroundColor = UIColor(named: "BackSecondary")
        layer.cornerRadius = 16
        
        textContainerInset = UIEdgeInsets(top: 17, left: 10, bottom: 12, right: 16)
        contentInsetAdjustmentBehavior = .automatic
        textAlignment = .left
        
        isScrollEnabled = false
        isEditable = true
    }
    
    init() {
        super.init(frame: .zero, textContainer: nil)
        textViewInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        textViewInit()
    }
    
}

class SegmentedControl: UISegmentedControl {
    
    let segmentControl: UISegmentedControl = {
        let control = UISegmentedControl()
        control.insertSegment(with: UIImage(named: "unimportant")?.withRenderingMode(.alwaysOriginal), at: 0, animated: false)
        control.insertSegment(withTitle: "нет", at: 1, animated: false)
        control.insertSegment(with: UIImage(named: "important")?.withRenderingMode(.alwaysOriginal), at: 2, animated: false)
        control.selectedSegmentIndex = 1
        
        return control
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        segmentControl.frame = bounds
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(segmentControl)
    }
    
}

class CustomScrollView: UIScrollView {
    
    lazy var scrollView: CustomScrollView = {
        let scrollView = CustomScrollView()
        scrollView.backgroundColor = UIColor(named: "BackPrimary")
        return scrollView
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing(true)
    }
}
