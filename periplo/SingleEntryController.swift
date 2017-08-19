//
//  SingleEntryController.swift
//  periplo
//
//  Created by Juan José Castro on 7/23/17.
//  Copyright © 2017 Juan José Castro. All rights reserved.
//

import UIKit
import Notepad
import MarkdownKit

class SingleEntryController: UIViewController, UITextViewDelegate {
    
    var entry: Entry? {
        didSet {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd, yyyy"
            navigationItem.title = formatter.string(from: entry!.date!)
        }
    }
    
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
    
    lazy var notepadView: UITextView = {
        let textView = UITextView()
        var style = NSMutableParagraphStyle()
        style.minimumLineHeight = 26
        
        let attributedString = NSMutableAttributedString(string: "NULL")
        let attributes = [NSParagraphStyleAttributeName: style,
                          NSForegroundColorAttributeName: UIColor.gray,
                          NSFontAttributeName: UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightRegular)] as [String : Any];
        attributedString.addAttributes(attributes, range: NSRange(location: 0, length: attributedString.length))
        textView.attributedText = attributedString
        return textView
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        notepadView.delegate = self
        notepadView.text = entry?.text
        
        compileText()
        
        NotificationCenter.default.addObserver(self, selector: #selector(saveData), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveData), name: NSNotification.Name.UIApplicationWillTerminate, object: nil)
        
//        automaticallyAdjustsScrollViewInsets = false
        
        edgesForExtendedLayout = []
        
        setupViews()
        setupNavBarButtons()
        configureKeyboardNotifications()
    }
    
    func configureKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(aNotification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(aNotification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(aNotification:NSNotification) {
        let info = aNotification.userInfo
        let infoNSValue = info![UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let kbSize = infoNSValue.cgRectValue.size
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0)
        notepadView.contentInset = contentInsets
        notepadView.scrollIndicatorInsets = contentInsets
    }
    
    func keyboardWillBeHidden(aNotification:NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        notepadView.contentInset = contentInsets
        notepadView.scrollIndicatorInsets = contentInsets
    }

    func compileText() {
        let attributedString = NSMutableAttributedString(attributedString: markdownParser.parse(notepadView.text))
        let style = NSMutableParagraphStyle()
        style.minimumLineHeight = 26
        attributedString.addAttributes([NSParagraphStyleAttributeName: style], range: NSRange(location: 0, length: attributedString.length))
        compiledTextView.attributedText = attributedString
    }
    
    private func setupNavBarButtons() {
        if let isFavorite = entry?.isFavorite?.boolValue {
            let favoriteBarButton = UIBarButtonItem(image: isFavorite ? #imageLiteral(resourceName: "heart") : #imageLiteral(resourceName: "heart-outline"), style: .plain, target: self, action: #selector(toggleFavorite))
            favoriteBarButton.tintColor = UIColor.rgb(255, 94, 255)
            
            let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            negativeSpacer.width = -8;
            favoriteBarButton.imageInsets = UIEdgeInsetsMake(0, 0, 0, -25.0)
            
            let editBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "pencil"), style: .plain, target: self, action: #selector(handleEdit))
            editBarButton.width = 20.0;
            navigationItem.rightBarButtonItems = [negativeSpacer, editBarButton, favoriteBarButton]
        }
    }
    
    func toggleFavorite() {
        if let isFavorite = entry?.isFavorite?.boolValue {
            entry!.isFavorite = !isFavorite as NSNumber
            navigationItem.rightBarButtonItems?[2].image = entry!.isFavorite!.boolValue ? #imageLiteral(resourceName: "heart") : #imageLiteral(resourceName: "heart-outline")
        }
    }
    
    func handleEdit() {
        notepadView.isHidden = false
        notepadView.becomeFirstResponder()
        compiledTextView.isHidden = true
        navigationItem.rightBarButtonItems?[1].image = #imageLiteral(resourceName: "save")
        navigationItem.rightBarButtonItems?[1].action = #selector(handleDone)
    }
    
    func handleDone() {
        compileText()
        notepadView.resignFirstResponder()
        notepadView.isHidden = true
        compiledTextView.isHidden = false
        navigationItem.rightBarButtonItems?[1].image = #imageLiteral(resourceName: "pencil")
        navigationItem.rightBarButtonItems?[1].action = #selector(handleEdit)
    }
    
    private func setupViews() {
        view.addSubview(notepadView)
        view.addSubview(compiledTextView)
        
        notepadView.isHidden = true
        notepadView.textContainerInset = UIEdgeInsetsMake(16, 16, 0, 16)
        compiledTextView.textContainerInset = UIEdgeInsetsMake(16, 16, 0, 16)
        
        view.addConstraintsWithFormat("V:|[v0]|", views: notepadView)
        view.addConstraintsWithFormat("H:|[v0]|", views: notepadView)
        view.addConstraintsWithFormat("V:|[v0]|", views: compiledTextView)
        view.addConstraintsWithFormat("H:|[v0]|", views: compiledTextView)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        entry?.text = textView.text
    }
    
    func saveData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            do {
                try context.save()
            } catch let err {
                print(err)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        handleDone()
        saveData()
    }
    
}
