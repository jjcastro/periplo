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
            if let title = entry?.title {
                titleLabel.text = title
            }
            
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
            
            if let preview = entry?.preview {
                let attributes = previewTextView.attributedText?.attributes(at: 0, effectiveRange: nil)
                let attributedString = NSMutableAttributedString(string: preview)
                attributedString.addAttributes(attributes!, range: NSRange(location: 0, length: attributedString.length))
                previewTextView.attributedText = attributedString
            }
            
            if let booleanValue = entry?.isFavorite, booleanValue as! Bool {
                starLabel.isHidden = false
            }
        }
    }
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "XX"
        label.font = UIFont.systemFont(ofSize: 30.0, weight: UIFontWeightHeavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dayNameLabel: UILabel = {
        let label = UILabel()
        
        let attributedString = NSMutableAttributedString(string: "NAN")
        label.translatesAutoresizingMaskIntoConstraints = false
       
        let attributes = [NSKernAttributeName: 1.5,
                          NSForegroundColorAttributeName: UIColor.blue,
                          NSFontAttributeName: UIFont.systemFont(ofSize: 13.0, weight: UIFontWeightBold)] as [String : Any];
        
        attributedString.addAttributes(attributes, range: NSRange(location: 0, length: attributedString.length))
        label.attributedText = attributedString
        
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "NULL"
        label.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightBold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let starLabel: UILabel = {
        let label = UILabel()
        label.text = "♥"
        label.textColor = UIColor.magenta
        label.font = UIFont.systemFont(ofSize: 20.0, weight: UIFontWeightBold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    let previewTextView: UITextView = {
        let textView = UITextView()
        textView.isUserInteractionEnabled = false
        let preview = "NULL"
        
        textView.textContainerInset = UIEdgeInsetsMake(0, -4, 0, 0)
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.textContainer.maximumNumberOfLines = 2;
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        var style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        
        let attributedString = NSMutableAttributedString(string: preview)
        let attributes = [NSParagraphStyleAttributeName: style,
                          NSForegroundColorAttributeName: UIColor.lightGray,
                          NSFontAttributeName: UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightRegular)] as [String : Any];
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
        
        addConstraintsWithFormat("H:|-16-[v0(40)]-13-[v1]-[v2(20)]-|", views: dayNameLabel, titleLabel, starLabel)
        addConstraintsWithFormat("H:|-16-[v0(40)]-12-[v1]-|", views: dateLabel, previewTextView)
        addConstraintsWithFormat("H:|-34-[v0(3)]-33-[v1]|", views: timelineViewBtm, separatorView)
        addConstraintsWithFormat("H:|-34-[v0(3)]", views: timelineViewTop, separatorView)
        
        addConstraintsWithFormat("V:|[v0(12)]-8-[v1(13)]-4-[v2(30)]-8-[v3]|", views: timelineViewTop, dayNameLabel, dateLabel, timelineViewBtm)
        addConstraintsWithFormat("V:|-16-[v0(20)]-8-[v1(48)]", views: titleLabel, previewTextView)
        addConstraintsWithFormat("V:|-14-[v0(24)]", views: starLabel)
        addConstraintsWithFormat("V:[v0(1)]|", views: separatorView)
    }
}
