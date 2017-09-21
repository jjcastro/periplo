//
//  MarkdownHelperStrip.swift
//  periplo
//
//  Created by Juan José Castro on 9/13/17.
//  Copyright © 2017 Juan José Castro. All rights reserved.
//

import UIKit

class MarkdownHelperStrip: UIScrollView {
    
    var managedTextView: UITextView
    
    var boldBtn: UIButton = {
        var btn = UIButton(type: UIButtonType.roundedRect)
        let attributes = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 15)]
        let title = NSAttributedString(string: "bold", attributes: attributes)
        btn.tintColor = UIColor.rgb(0, 89, 246)
        btn.setAttributedTitle(title, for: .normal)
        btn.addTarget(self, action: #selector(pressBold), for: .touchUpInside)
        return btn
    }()
    
    var italicBtn: UIButton = {
        var btn = UIButton(type: UIButtonType.roundedRect)
        let attributes = [NSAttributedStringKey.font: UIFont.italicSystemFont(ofSize: 15)]
        let title = NSAttributedString(string: "italic", attributes: attributes)
        btn.tintColor = UIColor.rgb(0, 89, 246)
        btn.setAttributedTitle(title, for: .normal)
        btn.addTarget(self, action: #selector(pressItalic), for: .touchUpInside)
        return btn
    }()
    
//    var heading1Btn: UIButton = {
//        var btn = UIButton(type: UIButtonType.roundedRect)
//        let attributes = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 17)]
//        let title = NSAttributedString(string: "heading", attributes: attributes)
//        btn.tintColor = UIColor.rgb(255, 94, 255)
//        btn.setAttributedTitle(title, for: .normal)
//        btn.addTarget(self, action: #selector(pressHeading(1)), for: .touchUpInside)
//        return btn
//    }()
//
//    var heading2Btn: UIButton = {
//        var btn = UIButton(type: UIButtonType.roundedRect)
//        let attributes = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)]
//        let title = NSAttributedString(string: "heading", attributes: attributes)
//        btn.tintColor = UIColor.rgb(255, 94, 255)
//        btn.setAttributedTitle(title, for: .normal)
//        btn.addTarget(self, action: #selector(pressHeading(2)), for: .touchUpInside)
//        return btn
//    }()
//
//    var heading3Btn: UIButton = {
//        var btn = UIButton(type: UIButtonType.roundedRect)
//        let attributes = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 15)]
//        let title = NSAttributedString(string: "heading", attributes: attributes)
//        btn.tintColor = UIColor.rgb(255, 94, 255)
//        btn.setAttributedTitle(title, for: .normal)
//        btn.addTarget(self, action: #selector(pressHeading(3)), for: .touchUpInside)
//        return btn
//    }()
    
    var separator: UIView = {
        var view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(textView: UITextView) {
        managedTextView = textView
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        super.init(frame: frame)
        backgroundColor = .white
        setupButtons()
    }
    
    @objc func pressBold() {
        let textViewContent = managedTextView.text
        managedTextView.isScrollEnabled = false
        let selectedRange = Range(managedTextView.selectedRange, in: textViewContent!)
        let offSet = managedTextView.selectedRange.length > 0 ? 4 : 2
        managedTextView.text = textViewContent?.replacingCharacters(in: selectedRange!, with: "**" + textViewContent![selectedRange!] + "**")
        managedTextView.selectedRange = NSMakeRange(selectedRange!.upperBound.encodedOffset + offSet, 0)
        managedTextView.isScrollEnabled = true
        managedTextView.delegate?.textViewDidChange!(managedTextView)
    }
    
    @objc func pressItalic() {
        let textViewContent = managedTextView.text
        managedTextView.isScrollEnabled = false
        let selectedRange = Range(managedTextView.selectedRange, in: textViewContent!)
        let offSet = managedTextView.selectedRange.length > 0 ? 2 : 1
        managedTextView.text = textViewContent?.replacingCharacters(in: selectedRange!, with: "*" + textViewContent![selectedRange!] + "*")
        managedTextView.selectedRange = NSMakeRange(selectedRange!.upperBound.encodedOffset + offSet, 0)
        managedTextView.isScrollEnabled = true
        managedTextView.delegate?.textViewDidChange!(managedTextView)
    }
    
    func setupButtons() {
        self.addSubview(boldBtn)
        self.addSubview(italicBtn)
//        self.addSubview(heading1Btn)
//        self.addSubview(heading2Btn)
//        self.addSubview(heading3Btn)
        self.addSubview(separator)
        
        addConstraintsWithFormat("V:|[v0(1)]-[v1]|", views: separator, boldBtn)
        addConstraintsWithFormat("V:|[v0(1)]-[v1]|", views: separator, italicBtn)
//        addConstraintsWithFormat("V:|[v0(1)]-[v1]|", views: separator, heading1Btn)
//        addConstraintsWithFormat("V:|[v0(1)]-[v1]|", views: separator, heading2Btn)
//        addConstraintsWithFormat("V:|[v0(1)]-[v1]|", views: separator, heading3Btn)
        addConstraintsWithFormat("H:|-[v0]-16-[v1]", views: boldBtn, italicBtn) // heading1Btn, heading2Btn, heading3Btn)
        
        addConstraints([NSLayoutConstraint(item: separator, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
