//
//  AboutController.swift
//  periplo
//
//  Created by Juan José Castro on 8/18/17.
//  Copyright © 2017 Juan José Castro. All rights reserved.
//

import UIKit
import MarkdownKit

class AboutController: UIViewController {
    
    var markdownParser: MarkdownParser = {
        let parser = MarkdownParser(font: UIFont.systemFont(ofSize: 16.0), automaticLinkDetectionEnabled: true, customElements: [])
        parser.header.fontIncrease = 1
        return parser
    }()
    
    var imageView: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "logo")
        return view
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Periplo"
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightHeavy)
        label.textAlignment = .center
        return label
    }()
    
    var compiledTextView: UITextView = {
        let view = UITextView()
        view.contentInset = UIEdgeInsetsMake(-14, 0, 0, 0);
        view.isEditable = false
        view.textAlignment = .center
        return view
    }()
    
    let info = "Version 1.0\n\nMade with tons of 💜 by [Juan Castro-Varón](http://castrovaron.com), somewhere in between Brooklyn and Bogotá.\n\n"
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        navigationItem.title = "About"
        
        compileText()
        setupViews()
    }
    
    func compileText() {
        let attributedString = NSMutableAttributedString(attributedString: markdownParser.parse(info))
        let style = NSMutableParagraphStyle()
        style.minimumLineHeight = 26
        style.alignment = .center
        attributedString.addAttributes([NSParagraphStyleAttributeName: style], range: NSRange(location: 0, length: attributedString.length))
        compiledTextView.attributedText = attributedString
    }
    
    func setupViews() {
        view.addSubview(compiledTextView)
        view.addSubview(titleLabel)
        view.addSubview(imageView)
        
        compiledTextView.textContainerInset = UIEdgeInsetsMake(16, 16, 0, 16)
        
        view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        
        view.addConstraintsWithFormat("V:|-32-[v0(76)]-16-[v1(20)][v2]|", views: imageView, titleLabel, compiledTextView)
        view.addConstraintsWithFormat("H:[v0(76)]", views: imageView)
        view.addConstraintsWithFormat("H:|[v0]|", views: titleLabel)
        view.addConstraintsWithFormat("H:|[v0]|", views: compiledTextView)
    }
    
    
    
}
