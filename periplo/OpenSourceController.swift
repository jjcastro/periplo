//
//  OpenSourceController.swift
//  periplo
//
//  Created by Juan José Castro on 8/18/17.
//  Copyright © 2017 Juan José Castro. All rights reserved.
//

import UIKit
import MarkdownKit

class OpenSourceController: UIViewController {
    
    var markdownParser: MarkdownParser = {
        let parser = MarkdownParser(font: UIFont.systemFont(ofSize: 16.0), automaticLinkDetectionEnabled: true, customElements: [])
        parser.header.fontIncrease = 1
        return parser
    }()
    
    var compiledTextView: UITextView = {
        let view = UITextView()
        view.isEditable = false
        return view
    }()
    
    let info = "Made with the help of these guys and their amazing open source contributions:\n\n* [SwipeCellKit](https://github.com/SwipeCellKit/SwipeCellKit) by [jerkoch](https://github.com/jerkoch), [kurabi](https://github.com/kurabi) & others.\n* [Notepad](https://github.com/ruddfawcett/Notepad) by [ruddfawcett](https://github.com/ruddfawcett).\n* [MarkdownKit](https://github.com/ivanbruel/MarkdownKit) by [ivanbruel](https://github.com/ivanbruel).\n\nThank you! 💜"
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        navigationItem.title = "Open Source"
        
        compileText()
        setupViews()
    }
    
    func compileText() {
        let attributedString = NSMutableAttributedString(attributedString: markdownParser.parse(info))
        let style = NSMutableParagraphStyle()
        style.minimumLineHeight = 26
        attributedString.addAttributes([.paragraphStyle: style], range: NSRange(location: 0, length: attributedString.length))
        compiledTextView.attributedText = attributedString
    }
    
    func setupViews() {
        view.addSubview(compiledTextView)
        compiledTextView.textContainerInset = UIEdgeInsetsMake(16, 16, 0, 16)
        
        view.addConstraintsWithFormat("V:|[v0]|", views: compiledTextView)
        view.addConstraintsWithFormat("H:|[v0]|", views: compiledTextView)
    }
}
