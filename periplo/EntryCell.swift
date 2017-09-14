//
//  EntryCell.swift
//  periplo
//
//  Created by Juan José Castro on 7/21/17.
//  Copyright © 2017 Juan José Castro. All rights reserved.
//

import UIKit

class EntryCell: BaseCell {
    
    var entry: Entry? {
        didSet {
            if let date = entry?.date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "E"
                
                let attributes = dayNameLabel.attributedText?.attributes(at: 0, effectiveRange: nil)
                let attributedString = NSMutableAttributedString(string: dateFormatter.string(from: date as Date).uppercased())
                attributedString.addAttributes(attributes!, range: NSRange(location: 0, length: attributedString.length))
                dayNameLabel.attributedText = attributedString
                
                dateFormatter.dateFormat = "dd"
                dateLabel.text = dateFormatter.string(from: date as Date)
            }
            
            if var entryText = entry?.text {
                let title = entryText.components(separatedBy: .newlines)[0]
                let length = title.count
                if length < 100 && title != "" {
                    titleLabel.text = title.replacingOccurrences(of: "^#*\\s*", with: "", options: .regularExpression)
                    if let from = entryText.index(entryText.startIndex, offsetBy: length, limitedBy: entryText.endIndex) {
                        let untrimmed = String(entryText[from...])
                        entryText = untrimmed.replacingOccurrences(of: "^\\n*", with: "", options: .regularExpression)
                    }
                }
                previewTextView.text = entryText
            }
            
            if let isFavorite = entry?.isFavorite {
                starLabel.isHidden = !isFavorite.boolValue
            }
        }
    }
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "XX"
        label.font = UIFont.systemFont(ofSize: 28.0, weight: UIFont.Weight.heavy)
        return label
    }()
    
    let dayNameLabel: UILabel = {
        let label = UILabel()
        
        let attributedString = NSMutableAttributedString(string: "NAN")
        let attributes: [NSAttributedStringKey : Any] = [.kern: 1.5, .foregroundColor: UIColor.rgb(0, 89, 246),
                                                         .font: UIFont.systemFont(ofSize: 13.0, weight: UIFont.Weight.bold)]
        
        attributedString.addAttributes(attributes, range: NSRange(location: 0, length: attributedString.length))
        label.attributedText = attributedString
        
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let starLabel: UILabel = {
        let label = UILabel()
        label.text = "♥"
        label.textColor = UIColor.rgb(255, 94, 255)
        label.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    let previewTextView: UITextView = {
        let textView = UITextView()
        textView.isUserInteractionEnabled = false

        textView.textContainerInset = UIEdgeInsetsMake(0, -4, 0, 0)
        textView.translatesAutoresizingMaskIntoConstraints = false
        var style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        
        let attributedString = NSMutableAttributedString(string: "NULL")
        let attributes: [NSAttributedStringKey : Any] = [.paragraphStyle: style, .foregroundColor: UIColor.lightGray, .font: UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.regular)]
        attributedString.addAttributes(attributes, range: NSRange(location: 0, length: attributedString.length))
        textView.attributedText = attributedString
        
        return textView
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(230, 230, 230)
        return view
    }()
    
    let timelineViewTop: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(230, 230, 230)
        return view
    }()
    
    let timelineViewBtm: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(230, 230, 230)
        return view
    }()
    
    override func setupViews() {
        addSubview(dateLabel)
        addSubview(dayNameLabel)
        addSubview(titleLabel)
        addSubview(previewTextView)
        addSubview(separatorView)
        addSubview(starLabel)
        addSubview(timelineViewTop)
        addSubview(timelineViewBtm)
        
        addConstraintsWithFormat("H:|-16-[v0(40)]-13-[v1]-[v2(20)]-12-|", views: dayNameLabel, titleLabel, starLabel)
        addConstraintsWithFormat("H:|-16-[v0(40)]-12-[v1]-|", views: dateLabel, previewTextView)
        addConstraintsWithFormat("H:|-34-[v0(3)]-33-[v1]|", views: timelineViewBtm, separatorView)
        addConstraintsWithFormat("H:|-34-[v0(3)]", views: timelineViewTop, separatorView)
        
        addConstraintsWithFormat("V:|[v0(12)]-10-[v1(11)]-4-[v2(30)]-8-[v3]|", views: timelineViewTop, dayNameLabel, dateLabel, timelineViewBtm)
        addConstraintsWithFormat("V:|-16-[v0(20)]-8-[v1(50)]", views: titleLabel, previewTextView)
        addConstraintsWithFormat("V:|-14-[v0(24)]", views: starLabel)
        addConstraintsWithFormat("V:[v0(1)]|", views: separatorView)
    }
}
